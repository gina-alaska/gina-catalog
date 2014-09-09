class Collection < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  validates :site_id, numericality: { only_integer: true }
end
