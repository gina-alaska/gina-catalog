class EntryPortal < ActiveRecord::Base
  belongs_to :portal
  belongs_to :entry, touch: true
end
