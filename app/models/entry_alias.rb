class EntryAlias < ActiveRecord::Base
  validates :slug, length: { maximum: 255 }
  validates :entry_id, numericality: { only_integer: true }
end
