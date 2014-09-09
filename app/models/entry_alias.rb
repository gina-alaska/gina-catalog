class EntryAlias < ActiveRecord::Base
  validates :slug, length: { maximum: 255 }
end
