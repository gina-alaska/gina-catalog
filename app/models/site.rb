class Site < ActiveRecord::Base
  acts_as_nested_set  
  
  validates :title, presence: true
  validates :acronym, presence: true
  validates :parent_id, presence: true
  
  scope :active, -> { }
end
