class Organization < ActiveRecord::Base
  include EntryDependentConcerns

  CATEGORIES = [
    'Academic',
    'Industry/Consultants',
    'State',
    'Federal',
    'Local',
    'Foundation',
    'Non-Governmental',
    'Unknown'
  ]

  dragonfly_accessor :logo

  has_many :entry_organizations
  has_many :entries, through: :entry_organizations

  has_many :entry_portals, through: :entries
  has_many :aliases, as: :aliasable, dependent: :destroy

  validates :name, length: { maximum: 255 }
  validates :category, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :acronym, length: { maximum: 15 }
  validates :adiwg_code, length: { maximum: 255 }
  validates :adiwg_path, length: { maximum: 255 }
  validates :logo_uid, length: { maximum: 255 }
  validates :logo_name, length: { maximum: 255 }
  validates :url, length: { maximum: 255 }

  validates_inclusion_of :category, :in => CATEGORIES, :message => " please select one of following: #{Organization::CATEGORIES.join(', ')}"

  accepts_nested_attributes_for :aliases, reject_if: ->(a) { a[:text].blank? }, allow_destroy: true

  # squeel doesn't work currently so having to disable this
  # scope :used_by_portal, ->(portal) {
  #   joins{entry_portals.outer}.where{ (entry_portals.portal == portal) | { created_at.gteq => 1.week.ago } }
  # }
  scope :used_by_portal, ->(portal) {
    includes(:entry_portals).references(:entry_portals).where('entry_portals.id = ? or organizations.created_at >= ?', portal.id, 1.week.ago)
  }

  def name_with_acronym
    "#{name} (#{acronym})"
  end
end
