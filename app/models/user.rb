class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  include PermissionConcerns

  has_many :activity_logs, as: :loggable
end
