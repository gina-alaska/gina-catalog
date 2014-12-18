class Agency < ActiveRecord::Base
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

  before_destroy :check_if_deletable, prepend: true
  
  has_many :entry_agencies
  has_many :entries, through: :entry_agencies
  
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

  validates_inclusion_of :category, :in => CATEGORIES, :message => " please select one of following: #{Agency::CATEGORIES.join(', ')}"

  accepts_nested_attributes_for :aliases, reject_if: ->(a) { a[:text].blank? }, allow_destroy: true
  
  scope :used_by_portal, ->(portal) { 
    joins{entry_portals.outer}.where{ (entry_portals.portal == portal) | { created_at.gteq => 1.week.ago } }
  }
  
  def deletable?
    self.entries.empty?
  end
  
  def not_deletable_reason
    if !self.entries.empty?
      "belongs to one or more catalog records"
    end
  end

  private 
  
  def check_if_deletable
    if !deletable?
      errors.add(:base, "Cannot delete agency, #{not_deletable_reason}")
      false
    end
  end
end
