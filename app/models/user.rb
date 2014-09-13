class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  include PermissionConcerns
end
