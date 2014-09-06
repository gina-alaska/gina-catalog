class Entry < ActiveRecord::Base
	belongs_to :site
	belongs_to :owner_site, class_name: 'Site'
	
  validates :title, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :uuid, length: { maximum: 255 }
end
