class Manager::ThemesController < ManagerController
  before_filter :authenticate_access_cms!
  
  SUBMENU = '/layouts/manager/cms_menu'
  PAGETITLE = 'Themes'

  def index
  end
  
  def new
    @theme = Theme.where(name: 'Default').first
    @theme = @theme.dup
    @theme.name = ""
  end
  
  def edit
    @theme = Theme.find(params[:id])
    if @theme.locked
      @theme = @theme.dup
      @theme.name = "Copy of #{@theme.name}"
    end
  end
  
  def create
    @theme = Theme.new(params[:theme])
    @theme.owner_setup = current_setup
    
    if @theme.save
      respond_to do |format|
        current_setup.theme = @theme
        current_setup.save!
        msg = "Created new #{@theme.name} theme"

        format.html {
          flash[:success] = msg
          if params["commit"] == "Save"
            redirect_to edit_manager_theme_path(@theme)
          else
            redirect_to manager_page_contents_path(tab: 'themes')
          end
        }

        format.js {
          if params["commit"] == "Save"
            flash.now[:success] = msg
          else
            flash[:success] = msg
            @redirect_to = manager_page_contents_path(tab: 'themes')
          end
          render '/shared/form_response'          
        }
      end
    else
      respond_to do |format|
        format.html {
          render :new
        }
      end
    end
  end
  
  def update
    @theme = Theme.find(params[:id])
    @theme.owner_setup = current_setup
    
    if @theme.owner_setup == current_setup and @theme.update_attributes(params[:theme])
      respond_to do |format|
        current_setup.theme = @theme
        current_setup.save!
        msg = "Updated #{@theme.name} theme"
          
        format.html {
          flash[:success] = msg
          if params["commit"] == "Save"
            redirect_to edit_manager_theme_path(@theme)
          else
            redirect_to manager_page_contents_path(tab: 'themes')
          end
        }

        format.js {
          if params["commit"] == "Save"
            flash.now[:success] = msg
          else
            flash[:success] = msg
            @redirect_to = manager_page_contents_path(tab: 'themes')
          end
          render '/shared/form_response'          
        }
      end
    else
      respond_to do |format|
        format.html {
          if @theme.owner_setup != current_setup
            flash[:error] = "You do not have permission to edit this theme"
          end
          render :edit
        }
      end
    end
  end
  
  def destroy
    @theme = Theme.find(params[:id])
    if current_setup.theme == @theme
      current_setup.theme = Theme.where(name: 'Default').first
      current_setup.save!
    end
      
    respond_to do |format|
      if @theme.owner_setup == current_setup and @theme.destroy
        format.html {
          flash[:success] = "Deleted #{@theme.name} theme"
          redirect_to manager_page_contents_path(tab: 'themes')
        }
      else
        format.html {
          flash[:error] = "Unable to delete #{@theme.name} theme"
          redirect_to manager_page_contents_path(tab: 'themes')
        }
      end
    end
  end
  
  def activate
    @theme = Theme.find(params[:id])
    
    if @theme.locked or @theme.owner_setup == current_setup
      current_setup.theme = @theme
    end
    
    respond_to do |format|
      if current_setup.save
        format.html {
          flash[:success] = "Activated #{@theme.name} theme"
          redirect_to manager_page_contents_path(tab: 'themes')
        }
      else
        format.html {
          flash[:error] = "Unable to activate #{@theme.name} theme"
          redirect_to manager_page_contents_path(tab: 'themes')
        }        
      end
    end
  end
end
