class EntrySite < ActiveRecord::Base
  belongs_to :site
  belongs_to :entry
end
