module EntrySearchConcerns
  extend ActiveSupport::Concern

  included do
    scope :search_import, -> { includes(:portals, :collections, :organizations, :archive) }
    delegate :name, to: :entry_type, prefix: true

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

  def data_type_names
    data_types.pluck(:name)
  end

  def region_names
    regions.pluck(:name)
  end

  def iso_topic_names
    iso_topics.pluck(:name)
  end

  def iso_topic_codes
    iso_topics.pluck(:iso_theme_code)
  end

  def attachment_file_names
    attachments.pluck(:file_name)
  end

  def attachment_description
    attachments.pluck(:description)
  end

  def attachment_category
    attachments.pluck(:category)
  end

  def search_data_with_entries
    as_json(methods: [
      :portal_ids, :tag_list, :collection_ids, :collection_names,
      :data_type_ids, :data_type_names, :region_ids, :region_names,
      :entry_type_name, :primary_organization_ids, :funding_organization_ids,
      :organization_categories, :organization_name, :primary_contact_ids,
      :contact_ids, :iso_topic_ids, :iso_topic_names, :iso_topic_codes,
      :archived?, :attachment_ids, :attachment_file_names, :attachment_description,
      :attachment_category
    ])
  end
end
