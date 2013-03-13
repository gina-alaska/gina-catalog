class Manager::RolesController < ManagerController
  def index
    @roles = current_setup.roles.all
  end
  
  def new
    @role = Role.new
    @permissions = Permission.all
  end
  
  def create
    @role = current_setup.roles.build(role_params)
    
    # @permissions = Permission.all
    # 
    # @permissions.each do |permission|
    #   form ||= params[permission.name]
    #   unless form.nil?
    #     @role.permissions << permission
    #   end
    # end

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
    # roleperm = @role.permissions
    # @permissions = Permission.all
    # 
    # @permissions.each do |permission|
    #   form ||= params[permission.name]
    #   if form.nil? and roleperm.include?(permission)
    #     @role.permissions.delete(permission)
    #   end
    #   unless form.nil? and !roleperm.include?(permission)
    #     @role.permissions << permission
    #   end
    # end
    
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
    @permissions = Permission.all
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