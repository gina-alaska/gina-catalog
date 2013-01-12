class Manager::PagesController < ManagerController
  before_filter :fetch_page, :except => [:new, :create]
  
  def new
    @page = @setup.pages.build
    @page.page_layout = @setup.page_layouts.where(default: true).first
    @page.parent = @setup.pages.find(params[:parent]) if params[:parent]
  end
  
  def edit
  end
  
  def add
    @page.sections = @page.sections << params[:new_page_name] unless @page.sections.include? params[:new_page_name]

    if @page.save
      render action: 'edit', layout: !request.xhr?
    else
      render action: 'edit', error: "Page could not be added", layout: !request.xhr?
    end 
  end
  
  def create
    @page = @setup.pages.build(params[:page])
    @setup.pages << @page
    
    if @page.save
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page created"
          redirect_to manager_path
        }
      end
    else
      respond_to do |format|
        format.html {
          render action: 'new'
        }
      end      
    end
  end
  
  def update
    if @page.update_attributes(params[:page])
      respond_to do |format|
        format.html {
          if params["commit"] == "Save"
            flash[:success] = "#{@page.title} page updated"
            render :edit
          else
            flash[:success] = "#{@page.title} page updated"
            redirect_to manager_path
          end
        }
      end
    else
      respond_to do |format|
        format.html {
          render action: 'edit'
        }
      end      
    end
  end
  
  def destroy
    if @page.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page deleted"
          redirect_to manager_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = "Unable to delete #{@page.title}"
          redirect_to manager_path
        }
      end
    end
  end
  
  def upload_image
    respond_to do |format|
      format.js
    end
  end
  
  protected
  
  def fetch_page
    @page = @setup.pages.find(params[:id])
  end
end
