class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  include PermissionConcerns

  searchkick word_start: [:name, :email]

  has_many :activity_logs, as: :loggable
end
