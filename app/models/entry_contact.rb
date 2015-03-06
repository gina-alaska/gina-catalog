class EntryContact < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :contact

  validates :contact_id, uniqueness: { scope: [:entry_id, :primary] }

  scope :primary, -> { where(primary: true) }
  scope :other, -> { where(primary: false) }
end
