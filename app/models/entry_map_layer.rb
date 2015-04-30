class EntryMapLayer < ActiveRecord::Base
  belongs_to :entry
  belongs_to :map_layer
end
