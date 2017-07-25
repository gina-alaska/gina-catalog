class Entry < ActiveRecord::Base
  include EntrySearchConcerns
  include LegacyConcerns
  include ArchiveConcerns
  include MustacheConcerns
  include PublicActivity::Model

  after_commit :check_for_multi_organizations

  STATUSES = %w[Complete Ongoing Unknown Funded].freeze

  acts_as_taggable_on :tags

  belongs_to :use_agreement
  belongs_to :entry_type

  has_many :attachments, dependent: :destroy
  has_many :bboxes, through: :attachments

  has_many :activity_logs, as: :loggable
  has_many :links, dependent: :destroy

  has_many :entry_organizations, validate: true, dependent: :destroy
  has_many :organizations, -> { uniq }, through: :entry_organizations
  has_many :primary_entry_organizations, -> { primary }, class_name: 'EntryOrganization'
  has_many :primary_organizations, -> { uniq }, through: :primary_entry_organizations, source: :organization
  has_many :funding_entry_organizations, -> { funding }, class_name: 'EntryOrganization'
  has_many :funding_organizations, -> { uniq }, through: :funding_entry_organizations, source: :organization
  has_many :other_entry_organizations, -> { other }, class_name: 'EntryOrganization'
  has_many :other_organizations, -> { uniq }, through: :other_entry_organizations, source: :organization

  has_many :entry_aliases, dependent: :destroy

  has_many :entry_collections, dependent: :destroy
  has_many :collections, through: :entry_collections

  has_many :entry_contacts, validate: true, dependent: :destroy
  has_many :contacts, through: :entry_contacts

  has_many :primary_entry_contacts, -> { primary }, class_name: 'EntryContact', dependent: :destroy
  has_many :primary_contacts, through: :primary_entry_contacts, source: :contact

  has_many :other_entry_contacts, -> { other }, class_name: 'EntryContact', dependent: :destroy
  has_many :other_contacts, through: :other_entry_contacts, source: :contact

  has_many :entry_iso_topics, dependent: :destroy
  has_many :iso_topics, through: :entry_iso_topics

  has_many :entry_data_types, dependent: :destroy
  has_many :data_types, through: :entry_data_types

  has_many :entry_portals, dependent: :destroy
  has_many :portals, -> { uniq }, through: :entry_portals

  has_many :entry_regions, dependent: :destroy
  has_many :regions, through: :entry_regions

  has_one :owner_entry_portal, -> { where owner: true }, class_name: 'EntryPortal', dependent: :destroy
  has_one :owner_portal, through: :owner_entry_portal, source: :portal, class_name: 'Portal'

  has_many :entry_map_layers, dependent: :destroy
  has_many :map_layers, through: :entry_map_layers

  has_many :download_logs, dependent: :destroy

  validates_associated :attachments
  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :portals, length: { minimum: 1, message: 'was empty, a catalog record must belong to at least one portal' }
  validate :check_for_single_ownership
  validates :description, presence: true
  validates :status, presence: true
  validates :entry_type_id, presence: true
  validate :single_primary_thumbnail

  accepts_nested_attributes_for :entry_collections, allow_destroy: true
  accepts_nested_attributes_for :entry_contacts, allow_destroy: true
  accepts_nested_attributes_for :entry_organizations, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true,
                                              reject_if: proc { |attachment| attachment['id'].blank? && attachment['file'].blank? }
  accepts_nested_attributes_for :links, allow_destroy: true,
                                        reject_if: proc { |link| link['url'].blank? }
  accepts_nested_attributes_for :entry_map_layers, allow_destroy: true

  after_create :set_owner_portal

  scope :newest, -> { order(created_at: :desc).limit(10) }
  scope :recently_updated, -> { order(updated_at: :desc).limit(10) }
  scope :published, -> { where('published_at <= ?', Time.zone.now) }

  tracked owner: proc { |controller, _model| controller.send(:current_user) },
          entry_id: :id,
          parameters: :activity_params

  def activity_params
    params = {}

    params[:use_agreement] = { id: use_agreement_id, display: use_agreement.try(:title) } if use_agreement_id_changed?
    params[:title] = { display: title } if title_changed?
    params[:description] = { display: true } if description_changed?
    params[:status] = { display: status } if status_changed?
    params[:type] = { display: entry_type.try(:name) } if entry_type_id_changed?
    params[:start_date] = { display: start_date } if start_date_changed?
    params[:end_date] = { display: end_date } if end_date_changed?

    params
  end

  def primary_thumbnail_count
    attachments.inject(0) { |c, v| v.category == 'Primary Thumbnail' ? c + 1 : c }
  end

  def single_primary_thumbnail
    errors.add(:attachments, 'has more than one Primary Thumbnail') if primary_thumbnail_count > 1
  end

  def set_owner_portal
    entry_portals.first.update_attribute(:owner, true) if owner_portal_count.zero?
  end

  def owner_portal_count
    entry_portals.inject(0) { |c, v| v.owner ? c + 1 : c }
  end

  def check_for_single_ownership
    errors.add(:portals, 'cannot specify more than one owner') if owner_portal_count > 1
  end

  def publish!
    return true if published?

    self.published_at = Time.zone.now
    save!
  end

  def unpublish!
    return true unless published?

    self.published_at = nil
    save!
  end

  def published?
    !published_at.nil?
  end

  def bbox
    srs_database = RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new
    factory = RGeo::Geos.factory(srs_database: srs_database, srid: 4326)
    bounds = RGeo::Cartesian::BoundingBox.new(factory)
    centroids.each do |centroid|
      bounds.add(centroid)
    end
    bounds.to_geometry
  end

  def bbox_centroid
    case bbox.geometry_type
    when RGeo::Feature::Point
      bbox
    when RGeo::Feature::Polygon
      bbox.point_on_surface
    else
      logger.info bbox.geometry_type
      nil
    end
  end

  def centroids
    attachments.geojson.map(&:centroid)
  end

  def to_s
    title
  end

  def to_param
    "#{id}-#{title.try(:truncate, 50).try(:parameterize)}"
  end

  def mustache_route
    "catalog_#{super}"
  end

  def as_context
    context = super
    context['type'] = entry_type.name

    context
  end

  def check_for_multi_organizations
    Entry.transaction do
      all_orgs = entry_organizations.group(:organization_id).count
      all_orgs.each do |organization_id, count|
        next unless count > 1
        new_assoc = entry_organizations.build(organization_id: organization_id)
        entry_organizations.where(organization_id: organization_id).each do |org|
          new_assoc.primary ||= org.primary
          new_assoc.funding ||= org.funding
        end
        entry_organizations.where(organization_id: organization_id).destroy_all
        new_assoc.save!
      end
    end
  end
end
