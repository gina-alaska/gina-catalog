class Address < ActiveRecord::Base
  validates :line1,            length: { maximum: 255 }
  validates :line2,            length: { maximum: 255 }
  validates :country,          length: { maximum: 255 }
  validates :state,            length: { maximum: 255 }
  validates :city,             length: { maximum: 255 }
  validates :zipcode,          length: { maximum: 255 }
  validates :addressable_type, length: { maximum: 255 }
end
