module EntrySearchConcerns
  extend ActiveSupport::Concern
  STOPWORDS = /\b(?:#{ %w(that [a-zA-Z]{1,3}).join('|') })\b/i
  SPACEWORDS = /\b(?:#{ %w[\s{2,}].join('|') })\b/i

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
    text += links.pluck(:display_text, :url, :category).flatten.uniq

    elasticsearch_word_strip text.join(' ').downcase
  end

  def search_data_with_entries
    data = as_json(methods: [
      :portal_ids, :tag_list, :collection_ids, :text_search_fields,
      :data_type_ids, :region_ids, :entry_type_name, :primary_organization_ids,
      :funding_organization_ids, :primary_contact_ids, :links_ids,
      :contact_ids, :iso_topic_ids, :archived?, :published?, :attachment_ids
    ])

    data['title'] = elasticsearch_word_strip data['title']
    data['description'] = elasticsearch_word_strip data['description']

    data
  end

  def elasticsearch_word_strip(data)
    data.gsub(/[\,\.:]/, '').gsub(STOPWORDS, '').gsub(SPACEWORDS, ' ').downcase
  end
end
