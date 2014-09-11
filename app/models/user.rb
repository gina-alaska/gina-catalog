class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  include PermissionConcerns
  
  has_many :site_users do 
    def for(site)
      where(site:site).first
    end
  end
  has_many :sites, through: :site_users
end
