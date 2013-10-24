class Manager::PageContentsController < ManagerController
  before_filter :authenticate_access_cms!
  before_filter :fetch_page, :except => [:new, :create, :index, :sort, :list_images]

  include CatalogConcerns::Ace
  before_filter :init_ace_editor, :only => [:new, :edit]

  SUBMENU = '/layouts/manager/cms_menu'
  PAGETITLE = 'Pages'
  SYSTEM_PAGES = ["sitemap", "search", "contacts", "404-not-found"]

  def index
    fetch_cms_pages
  end
  
  def new
    @page = current_setup.pages.build
    @page.page_layout = current_setup.layouts.where(default: true).first
    @page.parent = current_setup.pages.find(params[:parent]) if params[:parent]
    # @search = search_params
  end
  
  def edit
    # @search = search_params
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
    # @page.sections = @page.sections << params[:new_page_name] unless @page.sections.include? params[:new_page_name]
    if params[:new_tab_name]
      @page.sections = @page.sections << params[:new_tab_name].parameterize unless @page.sections.include? params[:new_tab_name]
      @page.save!
      @lock_version = @page.lock_version
      
      render 'add_tab'
    else
      render 'tab_name_form'
    end
  end
  
  def remove
    if params[:tab_name] and params[:tab_name] != 'body'
      @page.sections.delete_if { |section| section == params[:tab_name] }
      @page.save!
      @lock_version = @page.lock_version

      respond_to do |format|
        format.js
      end
    else
      render nothing: true
    end
  end

  def create
    @page = current_setup.pages.build(params[:page_content])
    @page.updated_by = current_user
    @page.system_page = true if SYSTEM_PAGES.include?(@page.slug)
    current_setup.pages << @page
    
    if @page.save
      @lock_version = @page.lock_version
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
      @lock_version = @page.lock_version
      
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
            flash.now[:success] = msg
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
  rescue ActiveRecord::StaleObjectError
    respond_to do |format|
      format.html {
        flash[:error] = "This file has changed after you started editing, please copy your changes and reload the page to continue editing."
        render action: 'edit'
      }
      format.js {
        flash.now[:error] = "This file has changed after you started editing, please copy your changes and reload the page to continue editing."
        render '/shared/form_response'
      }
    end
  end
  
  def preview
    @page.attributes = params[:page_content]
    
    respond_to do |format|
      format.html { render '/pages/show' }
    end
  end
  
  def destroy
    respond_to do |format|
      if @page.destroy
        format.html {
          flash[:success] = "#{@page.title} page deleted"
          redirect_to manager_page_contents_path
        }
      else
        format.html {
          flash[:error] = "Could not delete this page, some child pages where unable to be deleted"
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

  def search_params
    params[:search] || {}
  end
end
