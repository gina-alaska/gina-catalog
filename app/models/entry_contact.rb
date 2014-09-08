class EntryContact < ActiveRecord::Base
	belongs_to :entry
	belongs_to :contact
end
