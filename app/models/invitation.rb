class Invitation < ActiveRecord::Base
  belongs_to :site
  belongs_to :permission
  
  accepts_nested_attributes_for :permission
  
  validates :name, presence: true
  validates :email, presence: true
  
  def to_param
    self.uuid
  end
end
