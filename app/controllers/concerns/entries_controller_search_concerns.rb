module EntriesControllerSearchConcerns
  extend ActiveSupport::Concern

  def search(page, per_page = 20)
    # search_params
    @entries = Entry.search elasticsearch_params(page, per_page)
    @facets = OpenStruct.new(
      tags: organize_facets(@entries.aggs['tag_list']),
      collections: organize_facets(@entries.aggs['collection_ids'], Collection),
      iso_topics: organize_facets(@entries.aggs['iso_topic_ids'], IsoTopic),
      entry_types: organize_facets(@entries.aggs['entry_type_name']),
      data_types: organize_facets(@entries.aggs['data_type_ids'], DataType),
      regions: organize_facets(@entries.aggs['region_ids'], Region),
      status: organize_facets(@entries.aggs['status']),
      primary_organizations: organize_facets(@entries.aggs['primary_organization_ids'], Organization, :id, :acronym_with_name),
      funding_organizations: organize_facets(@entries.aggs['funding_organization_ids'], Organization, :id, :acronym_with_name),
      organization_categories: organize_facets(@entries.aggs['organization_categories']),
      primary_contacts: organize_facets(@entries.aggs['primary_contact_ids'], Contact),
      other_contacts: organize_facets(@entries.aggs['contact_ids'], Contact),
      archived: organize_facets(@entries.aggs['archived?'])
    ) if facets?
  end

  protected

  def facets?
    params[:format] != 'geojson'
  end

  def organize_facets(elastic_facets, model = nil, term_field = :id, display_field = :name)
    return [] if elastic_facets.nil?

    facets = elastic_facets['buckets'].each_with_object([]) do |f, memo|
      if !model.nil?
        facet_record = model.where(term_field => f['key']).first
        f['display_name'] = facet_record.try(display_field)
        f['hidden'] = facet_record.try(:hidden?)
      else
        f['display_name'] = f['key']
        f['hidden'] = false
      end

      memo << f
    end

    facets.sort { |a, b| a['doc_count'] == b['doc_count'] ? a['key'] <=> b['key'] : b['doc_count'] <=> a['doc_count'] }
  end

  FACET_FIELDS = {
    # search_field            # model_field_name
    tags:                     :tag_list,
    collections:              :collection_ids,
    iso_topics:               :iso_topic_ids,
    entry_type_name:          :entry_type_name,
    data_types:               :data_type_ids,
    regions:                  :region_ids,
    status:                   :status,
    primary_organizations:    :primary_organization_ids,
    funding_organizations:    :funding_organization_ids,
    organization_categories:  :organization_categories,
    primary_contacts:         :primary_contact_ids,
    other_contacts:           :contact_ids,
    archived:                 :archived?
  }

  def search_params
    if @search_params.nil?
      fields = [:starts_before, :starts_after, :ends_before, :ends_after, :order, :limit, :archived]
      fields << FACET_FIELDS.keys.each_with_object({}) { |f, c| c[f] = [] }

      @search_params = {}
      if params[:search].present?
        @search_params = params.require(:search).permit(:query, *fields)
      else
        @search_params[:order] = 'title'
      end
      @search_params[:archived] ||= false
    end

    @search_params
  end

  def date_search_params(after, before)
    date_search = {}
    if search_params[after].present?
      date_search[:gte] = Date.parse(search_params[after])
    end
    if search_params[before].present?
      date_search[:lte] = Date.parse(search_params[before])
    end

    date_search
  end

  def order_params
    case search_params[:order]
    when 'start_date'
      { start_date: :asc }
    when 'end_date'
      { end_date: :asc }
    when 'title'
      { title: :asc }
    when 'updated_at'
      { updated_at: :desc }
    end
  end

  def query_params
    {
      query_string: {
        query: search_params[:query],
        analyzer: 'snowball',
        # default_operator: "AND",
        # flags: 'OR|AND|PREFIX|NOT'
      }
    }
  end

  def search_facets
    a = FACET_FIELDS.values.each_with_object({}) { |f, c| c[f.to_s] = { limit: 50 } }
    logger.info a.inspect
    a
  end

  def elasticsearch_params(page, per_page = 20)
    opts = {
      # smart_facets: true,
      page: page,
      per_page: per_page,
      order: order_params,
      includes: [:bboxes],
      where: {
        portal_ids: current_portal.self_and_descendants.pluck(:id),
        start_date: date_search_params(:starts_after, :starts_before),
        end_date: date_search_params(:ends_after, :ends_before)
      }
    }
    opts[:aggs] = search_facets if facets?

    # items that must match all selected
    [:tags, :collections, :iso_topics, :organization_categories].each do |param|
      opts[:where][FACET_FIELDS[param]] = { all: search_params[param] } if search_params[param].present?
    end

    # items that can match any selected
    [:entry_type_name, :data_types, :regions, :status, :primary_organizations, :funding_organizations,
     :primary_contacts, :other_contacts, :archived].each do |param|
      opts[:where][FACET_FIELDS[param]] = search_params[param] if search_params[param].present?
    end
    opts[:where][:archived?] ||= false

    if cannot?(:read_unpublished, Entry)
      opts[:where][:published?] = true
    end

    opts[:query] = query_params if search_params[:query].present?

    opts
  end
end
