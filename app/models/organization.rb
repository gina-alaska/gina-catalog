class Organization < ActiveRecord::Base
  include EntryDependentConcerns
  searchkick word_start: %i[name acronym]

  CATEGORIES = [
    'Academic',
    'Industry/Consultants',
    'International',
    'State',
    'Federal',
    'Local',
    'Foundation',
    'Intergovernmental',
    'Non-Governmental',
    'Unknown'
  ].freeze

  dragonfly_accessor :logo

  has_many :entry_organizations
  has_many :entries, through: :entry_organizations

  has_many :entry_portals, through: :entries
  has_many :aliases, as: :aliasable, dependent: :destroy

  validates :name, length: { maximum: 255 }, uniqueness: true
  validates :category, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :acronym, length: { maximum: 15 }, uniqueness: true
  validates :adiwg_code, length: { maximum: 255 }
  validates :adiwg_path, length: { maximum: 255 }
  validates :logo_uid, length: { maximum: 255 }
  validates :logo_name, length: { maximum: 255 }
  validates :url, length: { maximum: 255 }

  validates :category, inclusion: { in: CATEGORIES, message: " please select one of following: #{Organization::CATEGORIES.join(', ')}" }

  accepts_nested_attributes_for :aliases, reject_if: ->(a) { a[:text].blank? }, allow_destroy: true

  # squeel doesn't work currently so having to disable this
  # scope :used_by_portal, ->(portal) {
  #   joins{entry_portals.outer}.where{ (entry_portals.portal == portal) | { created_at.gteq => 1.week.ago } }
  # }
  scope :used_by_portal, ->(portal) {
    query = 'entry_portals.portal_id = :portal_id or organizations.created_at >= :start_date'
    includes(:entry_portals).references(:entry_portals).where(query, portal_id: portal.id, start_date: 1.week.ago)
  }

  def name_with_acronym
    "#{name} (#{acronym})"
  end

  def acronym_with_name
    "(#{acronym}) #{name}"
  end
end
