class Admin::PortalsController < AdminController
  before_action :set_portal, only: %i[show edit update]
  load_and_authorize_resource

  def index
    @portals = Portal.active.roots.reorder('title ASC')
  end

  def show; end

  def new
    @portal = Portal.new
    @portal.urls.build
    @portal.build_favicon
  end

  def create
    @portal = Portal.new(portal_params)

    respond_to do |format|
      if @portal.save
        @portal.create_cms('portal_templates/default_cms.json')
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

  def entries
    @records = @portal.entries
    Rails.logger.info("entries count - #{@records.count}")
    @records.each do |entry|
      entry.destroy!
    end

    redirect_to [:admin, @portal]
  end

  protected

  def portal_params
    params.require(:portal).permit(
      :title, :acronym, :parent_id,
      permissions_attributes: [:id, :user_id, :_destroy, Permission::AVAILABLE_ROLES.keys],
      urls_attributes: %i[id url active _destroy],
      favicon: %i[id image_name image_uid]
    )
  end

  def set_portal
    @portal = Portal.find(params[:id])
  end
end
