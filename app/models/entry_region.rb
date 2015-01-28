class EntryRegion < ActiveRecord::Base
  belongs_to :region
  belongs_to :entry
end
