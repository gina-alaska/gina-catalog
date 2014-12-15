class EntryContact < ActiveRecord::Base
	belongs_to :entry
	belongs_to :contact

  scope :primary, -> { where(primary: true) }
  scope :secondary, -> { where(secondary: true) }
end
