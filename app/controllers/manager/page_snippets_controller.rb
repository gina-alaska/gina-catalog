class Manager::PageSnippetsController < ManagerController
  before_filter :authenticate_access_cms!
  
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
        format.html {
          flash[:success] = 'Successfully created snippet'
          if params[:commit] == 'Save'
            redirect_to edit_manager_page_snippet_path(@snippet)
          else
            redirect_to manager_page_contents_path(tab: "page_snippets")
          end
        }
      else
        format.html { render 'new' }
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
        format.html {
          flash[:success] = 'Successfully updated snippet'
          if params[:commit] == 'Save'
            redirect_to edit_manager_page_snippet_path(@snippet)
          else
            redirect_to manager_page_contents_path(tab: "page_snippets")
          end
        }
      else
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    @snippet = current_setup.snippets.find(params[:id])
    @snippet.destroy

    respond_to do |format|
      format.html {
        redirect_to manager_page_contents_path(tab: "page_snippets")
      }
      format.json { head :no_content }
    end
  end
end
