class Manager::PermissionsController < ManagerController
  before_action :fetch_permission, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    @permissions = current_portal.permissions.where.not(user_id: nil)
    @invitations = current_portal.invitations
  end

  def new
    @user = User.find(params[:user_id])
    @permission = current_portal.permissions.build(user: @user)
  end

  def create
    @permission = current_portal.permissions.build(permission_params)

    respond_to do |format|
      if @permission.save
        format.html do
          flash[:notice] = 'Permissions saved'
          redirect_to manager_permissions_path
        end
      else
        format.html do
          render :new
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @permission.update_attributes(permission_params)
        format.html do
          flash[:notice] = 'Permissions updated'
          redirect_to manager_permissions_path
        end
      else
        format.html do
          render :edit
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if @permission.destroy
        format.html do
          flash[:notice] = "User #{@permission.user} access has been removed"
          redirect_to manager_permissions_path
        end
      else
        format.html do
          flash[:notice] = "There was a problem removing access for #{@permission.user}"
          redirect_to manager_permissions_path
        end
      end
    end
  end

  def show
    redirect_to edit_manager_permission_path(@permission)
  end

  protected

  def permission_params
    params.require(:permission).permit(Permission::AVAILABLE_ROLES.keys + [:user_id])
  end

  def fetch_permission
    @permission = Permission.where(id: params[:id], portal: current_portal).first if params[:id].present?
  end
end
