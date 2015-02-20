class EntryAlias < ActiveRecord::Base
  belongs_to :entry, touch: true

  validates :slug, length: { maximum: 255 }
end
