class IsoTopic < ActiveRecord::Base
  include EntryDependentConcerns
  self.table_name = 'iso_topic_categories'

  searchkick word_start: %i[iso_theme_code name long_name long_name_with_code]

  has_many :entry_iso_topics
  has_many :entries, through: :entry_iso_topics

  validates :name, presence: true
  validates :name, length: { maximum: 50 }
  validates :name, uniqueness: true

  validates :long_name, length: { maximum: 200 }

  validates :iso_theme_code, presence: true
  validates :iso_theme_code, length: { maximum: 3 }
  validates :iso_theme_code, uniqueness: true

  def long_name_with_code
    "#{iso_theme_code} :: #{name.humanize} - #{long_name}"
  end

  def as_json(*opts)
    hash = super
    hash[:long_name_with_code] = long_name_with_code

    hash
  end
end
