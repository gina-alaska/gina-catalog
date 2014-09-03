class Admin::SitesController < AdminController
  before_action :set_site, only: [:show, :edit, :update]
  load_and_authorize_resource
  
  def index
    @sites = Site.active
  end
  
  def show
  end

  def new
    @site = Site.new
    @site.urls.build
  end
  
  def create
    @site = Site.new(site_params)
    
    respond_to do |format|
      if @site.save
        format.html {
          flash[:notice] = "Created site: #{@site.title}"
          redirect_to [:admin, @site]
        }
      else
        format.html {
          render 'new'
        }
      end
    end
  end
  
  def edit
    @site.urls.build
  end
  
  def update
    respond_to do |format|
      if @site.update_attributes(site_params)
        format.html { redirect_to [:admin, @site] }
      else
        format.html { render :edit }
      end
    end
  end
  
  protected
  
  def site_params
    params.require(:site).permit(:title, :acronym, :parent_id, urls_attributes: [:id, :url, :default])
  end
  
  def set_site
    @site = Site.find(params[:id])
  end
end
