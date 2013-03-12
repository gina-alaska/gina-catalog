class MembershipRole < ActiveRecord::Base
  #attr_accessible :membership_id, :role_id
  belongs_to :membership
  belongs_to :role
end
