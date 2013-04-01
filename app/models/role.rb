class Role < ActiveRecord::Base
  attr_accessible :permission_ids, :name, :description
  
  has_many :user_roles
  has_many :users, :through => :user_roles
  has_many :role_permissions, uniq: true
  has_many :permissions, :through => :role_permissions
  has_many :membership_roles
  has_many :memberships, :through => :membership_roles

  belongs_to :setup
end
