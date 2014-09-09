class Alias < ActiveRecord::Base
  validates :text, length: { maximum: 255 }
  validates :aliasable_type, length: { maximum: 255 }
end
