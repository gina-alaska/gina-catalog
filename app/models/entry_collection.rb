class EntryCollection < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :collection, counter_cache: true
end
