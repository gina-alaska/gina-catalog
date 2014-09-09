class Feedback < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :user_id, numericality: { only_integer: true }
  validates :site_id, numericality: { only_integer: true }
end
