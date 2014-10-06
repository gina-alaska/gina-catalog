class Entry < ActiveRecord::Base
	belongs_to :site
	belongs_to :owner_site, class_name: 'Site'
  belongs_to :use_agreement
	
  has_many :entry_contacts
  has_many :contacts, through: :entry_contacts
  has_many :entry_aliases
  has_many :entry_agencies
  has_many :agencies, through: :entry_agencies

  validates :title, length: { maximum: 255 }
  validates :slug, length: { maximum: 255 }
  validates :uuid, length: { maximum: 255 }
end
