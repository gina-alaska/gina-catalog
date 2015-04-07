module EntrySearchConcerns
  extend ActiveSupport::Concern

  included do
    scope :search_import, -> { includes(:portals, :collections, :organizations) }
    delegate :name, to: :entry_type, prefix: true
    delegate :name, to: :data_type, prefix: true, allow_nil: true

    searchkick
    alias_method_chain :search_data, :entries
  end

  def collection_names
    collections.pluck(:name)
  end

  def organization_categories
    organizations.pluck(:category)
  end

  def organization_name
    organizations.map { |org| "#{org.name} #{org.acronym}" }
  end
  
  def iso_topic_names 
    iso_topics.pluck(:name)
  end
  
  def iso_topic_codes
    iso_topics.pluck(:iso_theme_code)
  end

  def search_data_with_entries
    as_json(methods: [
      :portal_ids, :tag_list, :collection_ids, :collection_names, :data_type_name,
      :entry_type_name, :primary_organization_ids, :funding_organization_ids,
      :organization_categories, :organization_name, :primary_contact_ids,
      :contact_ids, :iso_topic_ids, :iso_topic_names, :iso_topic_codes
    ])
  end
end
