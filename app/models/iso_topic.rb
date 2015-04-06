class IsoTopic < ActiveRecord::Base
  include EntryDependentConcerns
  self.table_name = 'iso_topic_categories'

  searchkick word_start: [:iso_theme_code, :name, :long_name, :long_name_with_code]

  has_many :entry_iso_topics
  has_many :entries, through: :entry_iso_topics

  validates_presence_of :name
  validates_length_of :name, maximum: 50
  validates_uniqueness_of :name

  validates_length_of :long_name, maximum: 200

  validates_presence_of :iso_theme_code
  validates_length_of :iso_theme_code, maximum: 3
  validates_uniqueness_of :iso_theme_code

  def long_name_with_code
    "#{iso_theme_code} :: #{name.humanize} - #{long_name}"
  end

  def as_json(*opts)
    hash = super
    hash[:long_name_with_code] = long_name_with_code

    hash
  end
end
