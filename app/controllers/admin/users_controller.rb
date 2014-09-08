class Admin::UsersController < AdminController
  load_and_authorize_resource
  
  def index
    @users = User.order(:name)
  end
end
