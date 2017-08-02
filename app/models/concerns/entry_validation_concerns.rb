module EntryValidationConcerns
  extend ActiveSupport::Concern

  included do
    validates_associated :attachments
    validates :title, presence: true, length: { maximum: 255 }
    validates :slug, length: { maximum: 255 }
    validates :portals, length: { minimum: 1, message: 'was empty, a catalog record must belong to at least one portal' }
    validate :check_for_single_ownership
    validates :description, presence: true
    validates :status, presence: true
    validates :entry_type_id, presence: true
    validate :single_primary_thumbnail
  end

  def single_primary_thumbnail
    errors.add(:attachments, 'has more than one Primary Thumbnail') if primary_thumbnail_count > 1
  end

  def check_for_single_ownership
    errors.add(:portals, 'cannot specify more than one owner') if owner_portal_count > 1
  end
end
