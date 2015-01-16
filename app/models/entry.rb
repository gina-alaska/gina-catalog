class Entry < ActiveRecord::Base
  include EntrySearchConcerns

  STATUSES = %w(Complete Ongoing Unknown Funded)

  acts_as_taggable_on :tags

  belongs_to :use_agreement
  belongs_to :entry_type

  has_many :attachments, dependent: :destroy
  has_many :bboxes, through: :attachments

  has_many :activity_logs, as: :loggable
  has_many :links, dependent: :destroy

  has_many :entry_agencies
  has_many :agencies, through: :entry_agencies
  has_many :primary_entry_agencies, -> { primary }, class_name: "EntryAgency"
  has_many :primary_agencies, through: :primary_entry_agencies, source: :agency
  has_many :funding_entry_agencies, -> { funding }, class_name: "EntryAgency"
  has_many :funding_agencies, through: :funding_entry_agencies, source: :agency

  has_many :entry_aliases

  has_many :entry_collections
  has_many :collections, through: :entry_collections

  has_many :entry_contacts
  has_many :contacts, through: :entry_contacts

  has_many :primary_entry_contacts, -> { primary }, class_name: "EntryContact"
  has_many :primary_contacts, through: :primary_entry_contacts, source: :contact

  has_many :entry_portals
  has_many :portals, through: :entry_portals

  has_one :owner_entry_portal, -> { where owner: true }, class_name: 'EntryPortal'
  has_one :owner_portal, through: :owner_entry_portal, source: :portal, class_name: 'Portal'

  validates_associated :attachments
  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :portals, length: { minimum: 1, message: 'was empty, a catalog record must belong to at least one portal' }
  validate :check_for_single_ownership
  validates :description, presence: true
  validates :status, presence: true
  validates :entry_type_id, presence: true

  accepts_nested_attributes_for :entry_collections, allow_destroy: true
  accepts_nested_attributes_for :entry_contacts, allow_destroy: true
  accepts_nested_attributes_for :entry_agencies, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attachment| attachment['file'].blank? }
  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: proc { |link| link['url'].blank? }

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

  def publish(current_user = nil)
    return true if self.published?

    self.published_at = Time.zone.now
    # self.published_by = current_user.id
    save
  end

  def unpublish
    return true unless self.published?

    self.published_at = nil
    # self.published_by = nil
    save
  end

  def bbox
    srs_database = RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new
    factory = RGeo::Geos.factory(:srs_database => srs_database, :srid => 4326)
    bounds = RGeo::Cartesian::BoundingBox.new(factory)
    self.bboxes.each do |box|
      bounds.add(box.geom)
    end

    bounds.to_geometry
  end

  def published?
    !self.published_at.nil? && self.published_at <= Time.now.utc
  end
end
