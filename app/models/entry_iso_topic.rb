class EntryIsoTopic < ActiveRecord::Base
  belongs_to :iso_topic
  belongs_to :entry
end
