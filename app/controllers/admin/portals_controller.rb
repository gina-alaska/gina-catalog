class Admin::PortalsController < AdminController
  before_action :set_portal, only: [:show, :edit, :update]
  load_and_authorize_resource
  
  def index
    @portals = portal.active
  end
  
  def show
  end

  def new
    @portal = portal.new
    @portal.urls.build
  end
  
  def create
    @portal = portal.new(portal_params)
    
    respond_to do |format|
      if @portal.save
        format.html {
          flash[:notice] = "Created portal: #{@portal.title}"
          redirect_to [:admin, @portal]
        }
      else
        format.html {
          render 'new'
        }
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
    params.require(:portal).permit(:title, :acronym, :parent_id, urls_attributes: [:id, :url, :default])
  end
  
  def set_portal
    @portal = portal.find(params[:id])
  end
end
