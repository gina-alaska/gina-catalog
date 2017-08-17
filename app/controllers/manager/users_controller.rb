class Manager::UsersController < ManagerController
  def autocomplete
    @users = User.where('name ilike ? or email ilike ?', "%#{params[:query]}%", "%#{params[:query]}%")
    render json: (@users - current_portal.users).as_json(only: %i[id name email])
  end

  def index
    @users = current_portal.users
  end
end
