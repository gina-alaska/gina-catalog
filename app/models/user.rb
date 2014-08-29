class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  
  def admin?
    !self.new_record?
  end
end
