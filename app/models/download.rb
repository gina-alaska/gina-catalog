class Download < ActiveRecord::Base
  belongs_to :entry

  validates :name, length: { maximum: 255 }
  validates :file_type, length: { maximum: 255 }
  validates :url, length: { maximum: 255 }
  validates :uuid, length: { maximum: 255 }
end
