class Manager::PageSnippetsController < ManagerController
  before_filter :authenticate_access_cms!
  
  include CatalogConcerns::Ace
  before_filter :init_ace_editor, :only => [:new, :edit]

  PAGETITLE = 'Pages'
  SUBMENU = '/layouts/manager/cms_menu'
  
  def new
    @snippet = current_setup.snippets.build
  end
  
  def create
    @snippet = current_setup.snippets.build(params[:page_snippet])
    current_setup.snippets << @snippet
    
    respond_to do |format|
      if @snippet.save
        flash[:success] = 'Successfully created snippet'
        format.html {
          flash[:success] = 'Successfully created snippet'
          if params[:commit] == 'Save'
            redirect_to edit_manager_page_snippet_path(@snippet)
          else
            redirect_to manager_page_contents_path(tab: "page_snippets")
          end
        }
        format.js {
          if params["commit"] == "Save"
            @redirect_to = edit_manager_page_snippet_path(@snippet)
          else
            @redirect_to = manager_page_contents_path(tab: "page_snippets")
          end
          render '/shared/form_response'          
        }
      else
        format.html { render 'new' }
        format.js {       
          flash.now[:error] = @snippet.errors.full_messages
          render '/shared/form_response'
        }
      end
    end
  end
  
  def edit
    @snippet = current_setup.snippets.find(params[:id])
  end
  
  def update
    @snippet = current_setup.snippets.find(params[:id])
    respond_to do |format|
      if @snippet.update_attributes(params[:page_snippet])
        msg = 'Successfully updated snippet'
        format.html {
          flash[:success] = msg
          if params[:commit] == 'Save'
            redirect_to edit_manager_page_snippet_path(@snippet)
          else
            redirect_to manager_page_contents_path(tab: "page_snippets")
          end
        }
        format.js {
          if params["commit"] == "Save"
            flash.now[:success] = msg
          else
            flash[:success] = msg
            @redirect_to = manager_page_contents_path(tab: "page_snippets")
          end
          render '/shared/form_response'
        }
      else
        format.html { render 'edit' }
        format.js {       
          flash.now[:error] = @snippet.errors.full_messages
          render '/shared/form_response'
        }
      end
    end
  end

  def destroy
    @snippet = current_setup.snippets.find(params[:id])
    if @snippet.destroy
      respond_to do |format|
        format.html {
          redirect_to manager_page_contents_path(tab: "page_snippets")
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = @snippet.errors.full_messages.join(', ')
          redirect_to manager_page_contents_path(tab: "page_snippets")
        }
        format.json { head :no_content }
      end
    end
  end
end
