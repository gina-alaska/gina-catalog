class Collection < ActiveRecord::Base
  validates :name, length: { maximum: 255 }
  
  belongs_to :portal
  
  has_many :entry_collections
  has_many :entries, through: :entry_collections
  
end
