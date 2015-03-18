class ArchiveItem < ActiveRecord::Base
  belongs_to :archived, polymorphic: true, touch: true
  belongs_to :user

  scope :by_type, ->(type) { where(archived_type: type) }
  scope :entries, -> { by_type('Entry') }
end
