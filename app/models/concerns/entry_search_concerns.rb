module EntrySearchConcerns
  extend ActiveSupport::Concern

  included do
    scope :search_import, -> { includes(:portals, :collections, :organizations, :archive) }
    delegate :name, to: :entry_type, prefix: true

    searchkick
    alias_method_chain :search_data, :entries
  end

  def text_search_fields
    text = []
    text += collections.pluck(:name)
    text += organizations.pluck(:name, :acronym, :category).flatten.uniq
    text += data_types.pluck(:name)
    text += regions.pluck(:name)
    text += iso_topics.pluck(:name, :iso_theme_code).flatten.uniq
    text += attachments.pluck(:file_name, :description, :category).flatten.uniq
    text += contacts.pluck(:name, :email, :phone_number).flatten.uniq
  end

  def search_data_with_entries
    as_json(methods: [
      :portal_ids, :tag_list, :collection_ids, :text_search_fields,
      :data_type_ids, :region_ids, :entry_type_name, :primary_organization_ids,
      :funding_organization_ids, :primary_contact_ids,
      :contact_ids, :iso_topic_ids, :archived?, :attachment_ids
    ])
  end
end
