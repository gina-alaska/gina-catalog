module ArchiveConcerns
  extend ActiveSupport::Concern

  included do
    has_one :archive, as: :archived, class_name: 'ArchiveItem', dependent: :destroy
  end
end
