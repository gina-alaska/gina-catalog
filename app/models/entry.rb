class Entry < ActiveRecord::Base
  STATUSES = %w(Complete Ongoing Unknown Funded)

  acts_as_taggable_on :tags
  
  belongs_to :use_agreement
	
  has_many :entry_contacts
  has_many :contacts, through: :entry_contacts
  has_many :primary_entry_contacts, -> { primary }, class_name: "EntryContact"
  has_many :primary_contacts, through: :primary_entry_contacts, class_name: "Contact", source: :contact
  has_many :secondary_entry_contacts, -> { secondary }, class_name: "EntryContact"
  has_many :secondary_contacts, through: :secondary_entry_contacts, class_name: "Contact", source: :contact

  has_many :entry_aliases

  has_many :entry_agencies
  has_many :agencies, through: :entry_agencies
  
  has_many :entry_sites
  has_many :sites, through: :entry_sites
  
  has_one :owner_entry_site, -> { where owner: true }, class_name: 'EntrySite'
  has_one :owner_site, through: :owner_entry_site, source: :site, class_name: 'Site'

  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :sites, length: { minimum: 1, message: 'was empty, a catalog record must belong to at least one site' }
  validate :check_for_single_ownership
  validates :description, presence: true
  validates :status, presence: true
  
  accepts_nested_attributes_for :entry_contacts, allow_destroy: true
  accepts_nested_attributes_for :entry_agencies, allow_destroy: true

  after_create :set_owner_site
  
  def set_owner_site
    self.entry_sites.first.update_attribute(:owner, true)
  end
  
  def owner_site_count    
    self.entry_sites.inject(0) { |c,v| v.owner ? c+1 : c }
  end
  
  def check_for_single_ownership
    if owner_site_count > 1
      errors.add(:sites, 'cannot specify more than one owner')
    end
  end
end
