class Service < ActiveRecord::Base
	belongs_to :user

  attr_accessible :provider, :uid, :uname, :uemail, :user
  
  validates_associated :user
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    if user.nil? or user.new_record?
      user = User.create_from_hash!(hash)
    else
      user.update_from_hash!(hash)
    end
    
    Service.create(:user => user, :uid => hash['uid'], :provider => hash['provider'])
  end
end
