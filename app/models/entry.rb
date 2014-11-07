class Entry < ActiveRecord::Base
  STATUSES = %w(Complete Ongoing Unknown Funded)
  
  belongs_to :use_agreement
  belongs_to :entry_type
  	
  has_many :entry_contacts
  has_many :contacts, through: :entry_contacts
  has_many :primary_entry_contacts, -> { primary }, class_name: "EntryContact"
  has_many :primary_contacts, through: :primary_entry_contacts, class_name: "Contact", source: :contact
  has_many :secondary_entry_contacts, -> { secondary }, class_name: "EntryContact"
  has_many :secondary_contacts, through: :secondary_entry_contacts, class_name: "Contact", source: :contact

  has_many :entry_aliases

  has_many :entry_agencies
  has_many :agencies, through: :entry_agencies
  
  has_many :entry_portals
  has_many :portals, through: :entry_portals
  
  has_one :owner_entry_portal, -> { where owner: true }, class_name: 'EntryPortal'
  has_one :owner_portal, through: :owner_entry_portal, source: :portal, class_name: 'Portal'

  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :portals, length: { minimum: 1, message: 'was empty, a catalog record must belong to at least one portal' }
  validate :check_for_single_ownership
  validates :description, presence: true
  validates :status, presence: true
  validates :entry_type_id, presence: true
  
  accepts_nested_attributes_for :entry_contacts, allow_destroy: true
  accepts_nested_attributes_for :entry_agencies, allow_destroy: true

  after_create :set_owner_portal
  
  def set_owner_portal
    self.entry_portals.first.update_attribute(:owner, true)
  end
  
  def owner_portal_count    
    self.entry_portals.inject(0) { |c,v| v.owner ? c+1 : c }
  end
  
  def check_for_single_ownership
    if owner_portal_count > 1
      errors.add(:portals, 'cannot specify more than one owner')
    end
  end
end
