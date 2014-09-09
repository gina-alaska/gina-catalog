class Collection < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
end
