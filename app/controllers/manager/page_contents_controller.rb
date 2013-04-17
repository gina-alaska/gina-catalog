class Manager::PageContentsController < ManagerController
  before_filter :authenticate_access_cms!
  before_filter :fetch_page, :except => [:new, :create, :index, :sort]

  SUBMENU = '/layouts/manager/cms_menu'
  PAGETITLE = 'Pages'

  def index
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
        format.html {
          flash[:success] = "#{@page.title} page created"
          if params["commit"] == "Save"
            redirect_to edit_manager_page_content_path(@page)
          else
            redirect_to manager_page_contents_path
          end
        }
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
      end      
    end
  end
  
  def update
    @page.updated_by = current_user

    if @page.update_attributes(params[:page_content])
      
      respond_to do |format|
        format.html {
          flash[:success] = "#{@page.title} page updated"
          if params["commit"] == "Save"
            redirect_to edit_manager_page_content_path(@page)
          else
            redirect_to manager_page_contents_path
          end
        }
        format.js {
          flash.now[:success] = "#{@page.title} page updated"
          if params["commit"] == "Save"
          else
            @redirect_to = manager_page_contents_path
          end
        }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js { 
          flash.now[:error] = @catalog.errors.full_messages
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
