class Manager::UploadsController < ManagerController
  before_filter :authenticate_access_catalog!, except: [:share]
#  before_filter :authenticate_access_cms!
  before_filter :authenticate_edit_records!, only: [:edit, :new, :create, :update]
  
  def update
    @catalog = current_setup.catalogs.find(params[:id])
    if @catalog.handle_uploaded_file(params[:upload][:file])
      flash[:success] = "File uploaded successfully"
    else
      flash[:error] = "File not uploaded, destination file already exists!"
    end
    
    redirect_to manager_catalog_path(@catalog)
  end  
end
