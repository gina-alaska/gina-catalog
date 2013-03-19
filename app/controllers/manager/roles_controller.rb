class Manager::RolesController < ManagerController
  before_filter :authenticate_manage_site!

  def index
    @roles = current_setup.roles.all
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = current_setup.roles.build(role_params)
    
    respond_to do |format|
      if @role.save
        format.html do
          flash[:success] = "Created new role #{@role.name}"
          redirect_to manager_roles_path
        end
      else
        format.html do
          flash[:error] = 'Error while trying to create role'
          render 'new'
        end
      end
    end
  end
  
  def update
    @role = fetch_role
    
    respond_to do |format|
      if @role.update_attributes(role_params)
        format.html do
          flash[:success] = "Updated role #{@role.name}"
          redirect_to manager_roles_path
        end
      else
        format.html do
          flash[:error] = 'Error while trying to update role'
          render 'edit'
        end
      end
    end
  end
  
  
  def edit
    @role = fetch_role
  end
  
  def destroy
    @role = fetch_role
    if @role.destroy
      flash[:success] = "Deleted role #{@role.name}"
    else        
      flash[:error] = "Error while trying to delete role"
    end
    
    respond_to do |format|
      format.html do
        redirect_to manager_roles_path
      end
    end
  end
  
  protected
  
  def role_params
    rparams = params[:role].slice(:name, :description, :permission_ids)
  end
  
  def fetch_role
    current_setup.roles.find(params[:id])
  end
end