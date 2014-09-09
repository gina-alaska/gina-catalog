class Feedback < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
end
