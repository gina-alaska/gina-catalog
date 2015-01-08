class EntryCollection < ActiveRecord::Base
	belongs_to :entry
	belongs_to :collection, counter_cache: true
end
