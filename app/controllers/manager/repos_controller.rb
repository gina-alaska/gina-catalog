class Manager::ReposController < ManagerController
  respond_to :html
  
  before_filter :handle_git_format, :only => [:show]
  
  def show
    @repo = Repo.where(:slug => params[:id]).first
    redirect_to [:manager, @repo.catalog]
  end
  
  def update
    @catalog = current_setup.catalogs.find(params[:catalog_id])
    file = params[:repo][:file]
    
    if @catalog.repo and !@catalog.repo.exists?
      @catalog.repo.init
    end
    
    respond_to do |format|
      format.html {
        flash[:success] = @catalog.repo.add(file)
        @catalog.repo.async_create_archive        
        redirect_to [:manager, @catalog]
      }
    end
  end
  
  protected
  
  def handle_git_format
    request.format = :html if request.format == :git
  end
end
