class EntryContact < ActiveRecord::Base
	belongs_to :entry
	belongs_to :contact

  scope :primary, -> { where(primary: true) }
end
