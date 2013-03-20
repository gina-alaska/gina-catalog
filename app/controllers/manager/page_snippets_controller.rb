class Manager::PageSnippetsController < ManagerController
  before_filter :authenticate_access_cms!
  
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
            redirect_to manager_path
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
            redirect_to manager_path
          end
        }
      else
        format.html { render 'edit' }
      end
    end
  end
end
