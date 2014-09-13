class Manager::PermissionsController < ManagerController
  before_action :fetch_permission, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  def index
    @permissions = current_site.permissions
  end
  
  protected
  
  def fetch_permission
    @permission = Permission.where(id: params[:id], site: current_site).first if params[:id].present?
  end
end
