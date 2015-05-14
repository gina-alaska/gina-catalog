class EntryDataType < ActiveRecord::Base
  belongs_to :data_type
  belongs_to :entry
end
