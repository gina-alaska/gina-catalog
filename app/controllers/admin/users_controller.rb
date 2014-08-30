class Admin::UsersController < ApplicationController
  load_and_authorize_resource
  
  def index
    @users = User.order(:name)
  end
end
