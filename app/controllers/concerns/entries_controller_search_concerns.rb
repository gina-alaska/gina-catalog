module EntriesControllerSearchConcerns
  extend ActiveSupport::Concern

  def search(page, per_page = 20)
    @search_params = search_params
    @entries = Entry.search elasticsearch_params(page, per_page)

    @facets = OpenStruct.new(
      tags: organize_facets(@entries.facets['tag_list']),
      collections: organize_facets(@entries.facets['collection_ids'], Collection),
      entry_types: organize_facets(@entries.facets['entry_type_name']),
      status: organize_facets(@entries.facets['status']),
      primary_organizations: organize_facets(@entries.facets['primary_organization_ids'], Organization, :id, :acronym_with_name),
      funding_organizations: organize_facets(@entries.facets['funding_organization_ids'], Organization, :id, :acronym_with_name),
      organization_categories: organize_facets(@entries.facets['organization_categories']),
      primary_contacts: organize_facets(@entries.facets['primary_contact_ids'], Contact),
      other_contacts: organize_facets(@entries.facets['contact_ids'], Contact)
    ) if facets?
  end

  protected

  def facets?
    params[:format] != 'geojson'
  end

  def organize_facets(elastic_facets, model = nil, term_field = :id, display_field = :name)
    return [] if elastic_facets.nil?

    facets = elastic_facets['terms'].each_with_object([]) do |f, memo|
      f['display_name'] = model.nil? ? f['term'] : model.where(term_field => f['term']).first.try(display_field)
      memo << f
    end

    facets.sort { |a, b| a['count'] == b['count'] ? a['term'] <=> b['term'] : b['count'] <=> a['count'] }
  end

  FACET_FIELDS = {
    # search_field            # model_field_name
    tags:                     :tag_list,
    collections:              :collection_ids,
    entry_type_name:          :entry_type_name,
    status:                   :status,
    primary_organizations:    :primary_organization_ids,
    funding_organizations:    :funding_organization_ids,
    organization_categories:  :organization_categories,
    primary_contacts:         :primary_contact_ids,
    other_contacts:           :contact_ids
  }

  def search_params
    fields = [:starts_before, :starts_after, :ends_before, :ends_after, :order, :limit]
    fields << FACET_FIELDS.keys.each_with_object({}) { |f, c| c[f] = [] }

    if params[:search].present?
      @search_params ||= params.require(:search).permit(:query, *fields)
    end

    @search_params || {}
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
    FACET_FIELDS.values.each_with_object({}) { |f, c| c[f] = { limit: 50 } }
  end

  def elasticsearch_params(page, per_page = 20)
    opts = {
      smart_facets: true,
      page: page,
      per_page: per_page,
      order: order_params,
      include: [:bboxes],
      where: {
        portal_ids: current_portal.id,
        start_date: date_search_params(:starts_after, :starts_before),
        end_date: date_search_params(:ends_after, :ends_before)
      }
    }
    opts[:facets] = search_facets if facets?

    # items that must match all selected
    [:tags, :collections, :organization_categories].each do |param|
      opts[:where][FACET_FIELDS[param]] = { all: search_params[param] } if search_params[param].present?
    end

    # items that can match any selected
    [:entry_type_name, :status, :primary_organizations, :funding_organizations,
     :primary_contacts, :other_contacts].each do |param|
      opts[:where][FACET_FIELDS[param]] = search_params[param] if search_params[param].present?
    end

    opts[:query] = query_params if search_params[:query].present?

    opts
  end
end
