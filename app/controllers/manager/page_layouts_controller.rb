class Manager::PageLayoutsController < ManagerController
  before_filter :authenticate_access_cms!

  include CatalogConcerns::Ace
  before_filter :init_ace_editor, :only => [:new, :edit]

  PAGETITLE = 'Pages'
  SUBMENU = '/layouts/manager/cms_menu'
  
  # GET /setups/page_layouts/1
  # GET /setups/page_layouts/1.json
  def show
    @page_layout = current_setup.layouts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page_layout }
    end
  end

  # GET /setups/page_layouts/new
  # GET /setups/page_layouts/new.json
  def new
    @page_layout = current_setup.layouts.new
    @default_layout = check_for_default

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page_layout }
    end
  end

  # GET /setups/page_layouts/1/edit
  def edit
    @page_layout = current_setup.layouts.find(params[:id])
    @default_layout = check_for_default(@page_layout.id)
  end

  # POST /setups/page_layouts
  # POST /setups/page_layouts.json
  def create
    @page_layout = current_setup.layouts.build(params[:page_layout])
    change_default if params[:page_layout].delete("change_default")

    respond_to do |format|
      if @page_layout.save
        flash[:success] = "#{@page_layout.name} layout successfully created."
        format.html {
          if params["commit"] == "Save"
            redirect_to edit_manager_page_layout_path(@page_layout)
          else
            redirect_to manager_page_contents_path(tab: "page_layouts")
          end
        }
        format.js {
          if params["commit"] == "Save"
            @redirect_to = edit_manager_page_layout_path(@page_layout)
          else
            @redirect_to = manager_page_contents_path(tab: "page_layouts")
          end
          render '/shared/form_response'          
        }
        format.json { render json: @page_layout, status: :created, location: @page_layout }
      else
        format.html { render action: "new" }
        format.js {       
          flash.now[:error] = @page_layout.errors.full_messages
          render '/shared/form_response'
        }
        format.json { render json: @page_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /setups/page_layouts/1
  # PUT /setups/page_layouts/1.json
  def update
    @page_layout = current_setup.layouts.find(params[:id])
    change_default if params[:page_layout].delete(:change_default)

    respond_to do |format|
      if @page_layout.update_attributes(params[:page_layout])
        msg="#{@page_layout.name} layout successfully updated."
        format.html {
          flash[:success] = msg
          if params["commit"] == "Save"
            redirect_to edit_manager_page_layout_path(@page_layout)
          else
            redirect_to manager_page_contents_path(tab: "page_layouts")
          end
        }
        format.js {
          if params["commit"] == "Save"
            flash.now[:success] = msg
          else
            flash[:success] = msg
            @redirect_to = manager_page_contents_path(tab: "page_layouts")
          end
          render '/shared/form_response'
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js {       
          flash.now[:error] = @page_layout.errors.full_messages
          render '/shared/form_response'
        }
        format.json { render json: @page_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setups/page_layouts/1
  # DELETE /setups/page_layouts/1.json
  def destroy
    @page_layout = current_setup.layouts.find(params[:id])
    @page_layout.destroy

    respond_to do |format|
      format.html {
        redirect_to manager_page_contents_path(tab: "page_layouts")
        }
      format.json { head :no_content }
    end
  end

  protected

  def check_for_default(layout_id = nil)
    layout = current_setup.layouts.where(default: true)
    unless layout_id.nil? 
      layout = layout.where("page_layouts.id != ?", layout_id)
    end
    layout.any?
  end

  def change_default
    current_setup.layouts.where(default: true).update_all(default: false)
  end
end
