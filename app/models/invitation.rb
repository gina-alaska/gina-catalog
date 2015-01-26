class Invitation < ActiveRecord::Base
  belongs_to :portal
  belongs_to :permission
  
  accepts_nested_attributes_for :permission
  
  validates_presence_of :name
  validates_presence_of :email
  
  def to_param
    self.uuid
  end
end
