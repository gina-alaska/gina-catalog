class EntryAlias < ActiveRecord::Base
  belongs_to :entry

  validates :slug, length: { maximum: 255 }
end
