class EntryExport < ActiveRecord::Base
  serialize :serialized_search, JSON
end
