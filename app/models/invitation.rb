class Invitation < ActiveRecord::Base
  belongs_to :site
  belongs_to :permission
  
  accepts_nested_attributes_for :permission
end
