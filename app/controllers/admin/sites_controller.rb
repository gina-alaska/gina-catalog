class Admin::SitesController < AdminController
  before_action :set_site, only: [:show, :edit, :update]
  
  def index
  end
  
  def show
  end

  def new
    @site = Site.new
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
  
  protected
  
  def site_params
    params.require(:site).permit(:title, :acronym, :parent_id)
  end
  
  def set_site
    @site = Site.find(params[:id])
  end
end
