module EntrySearchConcerns
  extend ActiveSupport::Concern

  included do
    scope :search_import, -> { includes(:portals, :collections, :organizations) }
    delegate :name, to: :entry_type, prefix: true

    searchkick
    alias_method_chain :search_data, :entries
  end

  def collection_names
    self.collections.pluck(:name)
  end

  def organization_categories
    self.organizations.pluck(:category)
  end

  def organization_name
    self.organizations.map { |org| "#{org.name} #{org.acronym}"}
  end

  def search_data_with_entries
    as_json(methods: [:portal_ids, :tag_list, :collection_ids, :collection_names, :entry_type_name, :primary_organization_ids, :funding_organization_ids, :organization_categories, :organization_name, :primary_contact_ids, :contact_ids])
  end
end
