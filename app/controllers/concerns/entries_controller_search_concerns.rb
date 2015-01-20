module EntriesControllerSearchConcerns
  extend ActiveSupport::Concern

  def search
    @search_params = search_params
    @entries = Entry.search *elasticsearch_params

    @facets = OpenStruct.new(
      tags: organize_facets(@entries.facets['tag_list']),
      collections: organize_facets(@entries.facets['collection_ids']) { |id|
        Collection.where(id: id).first.try(:name) },
      entry_types: organize_facets(@entries.facets['entry_type_name']),
      status: organize_facets(@entries.facets['status']),
      primary_agencies: organize_facets(@entries.facets['primary_agency_ids']) { |id|
        Agency.where(id: id).first.try(:name) },
      funding_agencies: organize_facets(@entries.facets['funding_agency_ids']) { |id|
        Agency.where(id: id).first.try(:name) },
      agency_categories: organize_facets(@entries.facets['agency_categories']),
      primary_contacts: organize_facets(@entries.facets['primary_contact_ids']) { |id|
        Contact.where(id: id).first.try(:name) },
      other_contacts: organize_facets(@entries.facets['contact_ids']) { |id|
        Contact.where(id: id).first.try(:name) }
    )
    # @collections = Collection.where(id: @facets.collections.keys)
    # @entry_types = EntryType.order(name: :asc)
    # @tags = @facets.tags.keys
  end

  protected

  def organize_facets(facets, &block)
    return [] if facets.nil?

    facets['terms'].collect { |f|
      {
        term: f['term'],
        count: f['count'],
        display_name: block_given? ? yield(f['term']) : f['term']
      }
    }.sort { |a,b| a[:count] == b[:count] ? a[:term] <=> b[:term] : b[:count] <=> a[:count] }
  end

  FACET_FIELDS = {
    tags: :tag_list, collections: :collection_ids, entry_type_name: :entry_type_name,
    status: :status, primary_agencies: :primary_agency_ids, funding_agencies: :funding_agency_ids,
    agency_categories: :agency_categories, primary_contacts: :primary_contact_ids, other_contacts: :contact_ids
  }

  def search_params
    fields = [:starts_before, :starts_after, :ends_before, :ends_after]
    fields << FACET_FIELDS.keys.inject({}) { |c,f| c[f] = []; c }

    if params[:search].present?
      params.require(:search).permit(:query, *fields)
    else
      {}
    end
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

  def elasticsearch_params
    opts = {
      facets: FACET_FIELDS.values,
      smart_facets: true,
      page: params[:page] || 1,
      per_page: params[:limit] || 20
    }

    where = { portal_ids: current_portal.id }

    where[:start_date] = date_search_params(:starts_after, :starts_before)
    where[:end_date] = date_search_params(:ends_after, :ends_before)

    #items that must match all selected
    [:tags, :collections, :agency_categories].each do |param|
      where[FACET_FIELDS[param]] = { all: search_params[param] } if search_params[param].present?
    end

    #items that can match any selected
    [:entry_type_name, :status, :primary_agencies, :funding_agencies, :primary_contacts, :other_contacts].each do |param|
      where[FACET_FIELDS[param]] = search_params[param] if search_params[param].present?
    end

    opts[:query] = {
      query_string: {
        query: search_params[:query],
        analyzer: "snowball",
        # default_operator: "AND",
        # flags: 'OR|AND|PREFIX|NOT'
      }
    } if search_params[:query].present?

    opts[:where] = where

    query = search_params[:query]
    query = '*' if query.blank?

    [opts]
  end
end
