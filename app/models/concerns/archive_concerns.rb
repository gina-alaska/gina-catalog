module ArchiveConcerns
  extend ActiveSupport::Concern

  included do
    has_one :archive, as: :archived, class_name: 'ArchiveItem', dependent: :destroy
    scope :active, -> { includes(:archive).where(archive_items: { archived_id: nil }) }
  end

  def archived?
    !archive.nil?
  end

  def archive!(message, user)
    create_archive(message: message, user: user)
  end

  def unarchive!
    archive.destroy
  end
end
