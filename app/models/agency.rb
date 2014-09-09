class Agency < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  validates :category, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :acronym, length: { maximum: 15 }
  validates :adiwg_code, length: { maximum: 255 }
  validates :adiwg_path, length: { maximum: 255 }
  validates :logo_uid, length: { maximum: 255 }
  validates :logo_name, length: { maximum: 255 }
  validates :url, length: { maximum: 255 }
  validates :parent_id, numericality: { only_integer: true }
end
