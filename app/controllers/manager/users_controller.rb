class Manager::UsersController < ManagerController
  def autocomplete
    @users = User.where('name ilike ? or email ilike ?', "%#{params[:query]}%", "%#{params[:query]}%")
    render json: (@users - current_site.users).as_json(only: [:id, :name, :email])
  end

  def index
    @users = current_site.users
  end
end
