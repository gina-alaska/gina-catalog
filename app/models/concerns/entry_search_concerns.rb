module EntrySearchConcerns
  extend ActiveSupport::Concern

  included do
    scope :search_import, -> { includes(:portals, :collections, :agencies) }
    delegate :name, to: :entry_type, prefix: true

    searchkick
    alias_method_chain :search_data, :entries
  end

  def collection_names
    self.collections.pluck(:name)
  end

  def agency_categories
    self.agencies.pluck(:category)
  end

  def agency_name
    self.agencies.map { |a| "#{a.name} #{a.acronym}"}
  end

  def search_data_with_entries
    as_json(methods: [:portal_ids, :tag_list, :collection_ids, :collection_names, :entry_type_name, :primary_agency_ids, :funding_agency_ids, :agency_categories, :agency_name, :primary_contact_ids, :contact_ids])
  end
end
