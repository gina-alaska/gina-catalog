class EntryContact < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :contact

  scope :primary, -> { where(primary: true) }
  scope :other, -> { where(primary: false) }
end
