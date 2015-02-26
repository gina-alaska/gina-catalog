class EntryContact < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :contact

  scope :primary, -> { where(primary: true) }
end
