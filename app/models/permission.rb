class Permission < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :role_permissions
  has_many :roles, through: :role_permissions
  
  validates_uniqueness_of :name, scope: :group
end
