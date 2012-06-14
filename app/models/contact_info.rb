class ContactInfo < ActiveRecord::Base
  belongs_to :catalog
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :usage_description
end
