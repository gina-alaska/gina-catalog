class Entry < ActiveRecord::Base
  include EntryRelationConcerns
  include EntryPublicActivityConcerns
  include EntryValidationConcerns
  include EntrySearchConcerns
  include LegacyConcerns
  include ArchiveConcerns
  include MustacheConcerns

  after_commit :consolidate_organizations
  after_create :set_owner_portal

  STATUSES = %w[Complete Ongoing Unknown Funded].freeze

  acts_as_taggable_on :tags

  scope :newest, -> { order(created_at: :desc).limit(10) }
  scope :recently_updated, -> { order(updated_at: :desc).limit(10) }
  scope :published, -> { where('published_at <= ?', Time.zone.now) }

  def primary_thumbnail_count
    attachments.inject(0) { |c, v| v.category == 'Primary Thumbnail' ? c + 1 : c }
  end

  def set_owner_portal
    entry_portals.first.update_attribute(:owner, true) if owner_portal_count.zero?
  end

  def owner_portal_count
    entry_portals.inject(0) { |c, v| v.owner ? c + 1 : c }
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
    factory = ::RGeo::Cartesian.preferred_factory(srid: 4326)

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

  def consolidate_organizations
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
