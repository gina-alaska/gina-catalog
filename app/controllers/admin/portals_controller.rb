class Admin::PortalsController < AdminController
  before_action :set_portal, only: [:show, :edit, :update]
  load_and_authorize_resource

  def index
    @portals = Portal.active
  end

  def show
  end

  def new
    @portal = Portal.new
    @portal.urls.build
    @portal.build_favicon
  end

  def create
    @portal = Portal.new(portal_params)

    respond_to do |format|
      if @portal.save
        format.html do
          flash[:notice] = "Created portal: #{@portal.title}"
          redirect_to [:admin, @portal]
        end
      else
        format.html do
          render 'new'
        end
      end
    end
  end

  def edit
    @portal.urls.build
  end

  def update
    respond_to do |format|
      if @portal.update_attributes(portal_params)
        format.html { redirect_to [:admin, @portal] }
      else
        format.html { render :edit }
      end
    end
  end

  protected

  def portal_params
    params.require(:portal).permit(
      :title, :acronym, :parent_id,
      permissions_attributes: [:id, :user_id, :_destroy, Permission::AVAILABLE_ROLES.keys],
      urls_attributes: [:id, :url, :default, :_destroy],
      favicon: [:id, :image_name, :image_uid])
  end

  def set_portal
    @portal = Portal.find(params[:id])
  end
end
