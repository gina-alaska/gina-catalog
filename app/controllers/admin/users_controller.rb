class Admin::UsersController < AdminController
  load_and_authorize_resource

  def index
    @users = User.order(:name)
  end

  def new; end

  def edit; end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        flash[:success] = "User #{@user.name} was updated."
        format.html { redirect_to admin_users_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def user_params
    params.require(:user).permit(:global_admin)
  end
end
