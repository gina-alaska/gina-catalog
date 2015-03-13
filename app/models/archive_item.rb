class ArchiveItem < ActiveRecord::Base
  belongs_to :archived, polymorphic: true

  scope :by_type, ->(type) { where(archived_type: type) }
  scope :entries, -> { by_type('Entry') }
   
end
