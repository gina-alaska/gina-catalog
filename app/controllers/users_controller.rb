class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.json {
        render :json => { :users => @users }
      }
    end
  end

  def preferences
    respond_to do |format|
      format.json {
        render :json => { :user => current_user }
      }
    end
  end
end
