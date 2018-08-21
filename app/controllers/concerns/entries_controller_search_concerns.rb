module EntriesControllerSearchConcerns
  extend ActiveSupport::Concern

  class Aggregates
    def initialize(entries, portal)
      @entries = entries
      @portal = portal
    end

    def fetch
      OpenStruct.new(
        tags: organize(:tag_list),
        collections: organize(:collection_ids, Collection),
        iso_topics: organize(:iso_topic_ids, IsoTopic),
        entry_types: organize(:entry_type_name),
        data_types: organize(:data_type_ids, DataType),
        regions: organize(:region_ids, Region),
        status: organize(:status),
        primary_organizations: organize(:primary_organization_ids, Organization, :id, :acronym_with_name),
        funding_organizations: organize(:funding_organization_ids, Organization, :id, :acronym_with_name),
        organization_categories: organize(:organization_categories),
        primary_contacts: organize(:primary_contact_ids, Contact),
        other_contacts: organize(:contact_ids, Contact),
        archived: organize(:archived?)
      )
    end

    def organize(facet_name, model = nil, term_field = :id, display_field = :name)
      portal_obj = %w{ collection_ids primary_contact_ids contact_ids }

      elastic_facets = @entries.aggs[facet_name.to_s]
      return [] if elastic_facets["buckets"].blank?

      facets = elastic_facets['buckets'].each_with_object([]) do |f, memo|
        if !model.nil?
          if portal_obj.include?(facet_name.to_s)
            facet_record = model.where(term_field => f['key'], :used_by_portal => true)
          else
            facet_record = model.where(term_field => f['key']).first
          end

          next if facet_record.try(display_field).nil?

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
  end

  def search(page, per_page = 20)
    # search_params
    @entries = Entry.search elasticsearch_params(page, per_page)

    return unless facets?

    aggs = Aggregates.new(@entries, current_portal)
    @facets = aggs.fetch
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
  }.freeze

  def search_params
    if @search_params.nil?
      fields = %i[starts_before starts_after ends_before ends_after order limit archived]
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

  def query_params
    query_string = search_params[:query]
    query_string = '*' if query_string.blank?

    {
      query_string: {
        query: query_string,
        default_field: '_all'
      }
    }
  end

  def search_facets
    FACET_FIELDS.values.each_with_object({}) { |f, c| c[f.to_s] = { limit: 50 } }
  end

  def facet_field_search
    search = []
    FACET_FIELDS.keys.each do |param|
      next unless search_params[param].present?
      search << term_query_filter(FACET_FIELDS[param], search_params[param])
    end

    search
  end

  # this makes use of elastic search query syntax
  def elasticsearch_params(page, per_page = 20)
    page ||= 1
    offset = (page.to_i - 1) * per_page.to_i

    {
      body: {
        sort: order_params,
        query: elasticsearch_query,
        aggs: aggregates,
        post_filter: {
          bool: {
            filter: [{
              in: {
                portal_ids: current_portal.self_and_descendants.pluck(:id)
              }
            }]
          }
        },
        size: per_page,
        from: offset
      },
      page: page,
      per_page: per_page
    }
  end

  def elasticsearch_query
    custom_query = { bool: { must: [query_params] } }

    custom_query[:bool][:must] += facet_field_search unless facet_field_search.empty?

    start_date_filter = range_query_filter(:start_date, :starts_after, :starts_before)
    custom_query[:bool][:must] << start_date_filter if start_date_filter

    end_date_filter = range_query_filter(:end_date, :ends_after, :ends_before)
    custom_query[:bool][:must] << end_date_filter if end_date_filter

    # user filter here to keep it from affecting the result score
    custom_query[:bool][:filter] ||= []
    if cannot?(:read_unpublished, Entry)
      custom_query[:bool][:filter] << term_query_filter(:published?, true)
    end

    custom_query[:bool][:filter] << term_query_filter(:archived?, search_params[:archived])

    custom_query
  end

  def order_params
    order_by =
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

    [order_by, '_score'].compact
  end

  def date_search_params(after, before)
    date_search = nil

    if search_params[after].present?
      date_search ||= {}
      date_search[:gte] = Date.parse(search_params[after])
    end
    if search_params[before].present?
      date_search ||= {}
      date_search[:lte] = Date.parse(search_params[before])
    end

    date_search
  end

  def range_query_filter(field, after, before)
    filter = date_search_params(after, before)
    return false if filter.nil?

    { range: { field => date_search_params(after, before) } }
  end

  def term_query_filter(name, value)
    if value.is_a? Array
      { terms: { name => value } }
    else
      { term: { name => value } }
    end
  end

  def aggregates
    FACET_FIELDS.each_with_object({}) do |f, c|
      field = f[1]

      c[field] = {
        terms: {
          field: field,
          size: 50
        }
      }
    end
  end
end
