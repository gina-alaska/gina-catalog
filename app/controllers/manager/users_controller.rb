class Manager::UsersController < ManagerController
  def index
    if params[:q] and !params[:q].empty?
      search = User.search do
        fulltext params[:q]
        order_by 'last_name', :asc
      end
      @users = search.results
    else
      @users = User.includes(:roles).order('last_name ASC, first_name ASC').all
    end
  end
  
  def show
    @user = fetch_user
  end
  
  def update
    @user = fetch_user
    roles = user_params[:roles].collect do |role|
      Role.where(name: role).first
    end
    @user.agency_id = user_params[:agency_id]
    @user.roles = roles.compact
    respond_to do |format|
      if @user.save
        format.html do
          flash[:success] = "Updated settings for #{@user.fullname}"
          redirect_to manager_users_path
        end
      end
    end
  end
  
  protected
  
  def user_params
    p = params[:user].slice(:roles, :agency_id)
    p['roles'] = p['roles'].collect { |k,v| k if v.to_i == 1 }.compact
    p
  end
  
  def fetch_user
    User.includes(:roles).find(params[:id])
  end
end