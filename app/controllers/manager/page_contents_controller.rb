class Manager::PageContentsController < ManagerController
  before_filter :authenticate_access_cms!
  before_filter :fetch_page, :except => [:new, :create, :index, :sort, :list_images]

  SUBMENU = '/layouts/manager/cms_menu'
  PAGETITLE = 'Pages'

  def index
    fetch_cms_pages
  end
  
  def new
    @page = current_setup.pages.build
    @page.page_layout = current_setup.layouts.where(default: true).first
    @page.parent = current_setup.pages.find(params[:parent]) if params[:parent]
  end
  
  def edit
  end
  
  def sort
    left_page = nil
    Page::Content.transaction do
      params[:pages].dup.each do |k, item|
        page = current_setup.pages.find(item['id'])        
        unless left_page.nil?
          page.move_to_right_of left_page
        end
        left_page = page
        
        if item['children']
          sort_children(page, item['children'])
        end
      end
    end
    
    respond_to do |format|
      format.js {
        flash[:success] = 'Successfully reordered the pages'
        render :text => 'location.reload();'
      }
    end
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
    @page = current_setup.pages.build(params[:page_content])
    current_setup.pages << @page
    @page.updated_by = current_user
    
    if @page.save
      respond_to do |format|
        flash[:success] = "#{@page.title} page created"
        format.html {
          if params["commit"] == "Save"
            redirect_to edit_manager_page_content_path(@page)
          else
            redirect_to manager_page_contents_path
          end
        }
        format.js {
          if params["commit"] == "Save"
            @redirect_to = edit_manager_page_content_path(@page)
          else
            @redirect_to = manager_page_contents_path
          end
          render '/shared/form_response'          
        }
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js {       
          flash.now[:error] = @page.errors.full_messages
          render '/shared/form_response'
        }
      end      
    end
  end
  
  def update
    @page.updated_by = current_user

    if @page.update_attributes(params[:page_content])
      msg = "#{@page.title} page updated"
      
      respond_to do |format|
        format.html {
          flash[:success] = msg
          if params["commit"] == "Save"
            redirect_to edit_manager_page_content_path(@page)
          else
            redirect_to manager_page_contents_path
          end
        }
        format.js {
          if params["commit"] == "Save"
            flash.now[:success] = msg
          else
            flash[:success] = msg
            @redirect_to = manager_page_contents_path
          end
          render '/shared/form_response'
        }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js { 
          flash.now[:error] = @page.errors.full_messages
          render '/shared/form_response'
        }
      end      
    end
  end
  
  def preview
    @page.attributes = params[:page_content]
    
    respond_to do |format|
      format.html { render '/pages/show' }
    end
  end
  
  def destroy
    if @page.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page deleted"
          redirect_to manager_page_contents_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = "Unable to delete #{@page.title}"
          redirect_to manager_page_contents_path
        }
      end
    end
  end
  
  def upload_image
    respond_to do |format|
      format.js
    end
  end

  def list_images
    search_params = params[:search] || {}
    if search_params.keys.count > 0
      solr = Image.search do
        logger.info(search_params.inspect)
        fulltext search_params[:q]
      end
      @images = solr.results
    else
      @images = current_setup.images.order('title ASC')
    end
    @search = search_params

    respond_to do |format|
      format.js
    end
  end
  
  protected
  
  def sort_children(parent, items)
    left_page = nil
    
    items.each do |k, i|
      page = current_setup.pages.find(i['id'])
      
      if left_page.nil?
        page.move_to_child_of parent if page.parent != parent
        left_page = page
      else
        page.move_to_right_of left_page
        left_page = page
      end
      
      if i['children']
        sort_children(page, i['children'])
      end
    end
  end
  
  def fetch_page
    @page = current_setup.pages.find(params[:id])
  end
end
