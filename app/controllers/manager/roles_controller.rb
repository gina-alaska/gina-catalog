class Manager::RolesController < ManagerController
  def index
    @roles = Role.all
  end
  
  def new
    @role = Role.new
  end
  
  def create
    @role = Role.new(role_params)
    
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
    params[:role].slice(:name, :description)
  end
  
  def fetch_role
    Role.find(params[:id])
  end
end