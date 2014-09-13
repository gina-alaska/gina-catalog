class Manager::UsersController < ManagerController
  def autocomplete
    @users = User.where('name ilike ? or email ilike ?', "%#{params[:query]}%", "%#{params[:query]}%")
    render json: @users.as_json(only: [ :name, :email ])
  end
end
