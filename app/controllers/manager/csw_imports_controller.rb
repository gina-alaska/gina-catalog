class Manager::CswImportsController < ManagerController

  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'CSW Imports'
  
  def index
    @csw_imports = current_setup.csw_imports #CswImport.where(setup_id: current_setup)
    respond_to do |format|
      format.html
    end
  end

  def show
    @csw_import = current_setup.csw_imports.where(id: params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @csw_import = current_setup.csw_imports.build #CswImport.new(setup_id: current_setup)
    
    respond_to do |format|
      format.html
    end    
  end

  def create
    @csw_import = current_setup.csw_imports.build(params[:csw_import])
    
    respond_to do |format|
      if @csw_import.save
        flash[:success] = 'CSW Import was successfully created.'
        format.html { redirect_to manager_csw_imports_path }
      else
        format.html { render action: "new" }
        format.json { render json: @csw_import.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @csw_import = current_setup.csw_imports.find(params[:id])
  end
  
  def update
    @csw_import = current_setup.csw_imports.find(params[:id])

    respond_to do |format|
      if @csw_import.update_attributes(params[:csw_import])
        flash[:success] = "CSW Import #{@csw_import.title} was successfully updated."
        format.html { redirect_to manager_csw_imports_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @csw_import.errors, status: :unprocessable_entity }
      end
    end
  end
    

  def destroy
    respond_to do |format|
      flash[:success] = 'Contact was successfully deleted.'
      format.html { redirect_to manager_contacts_path }
      format.json { head :no_content }
    end
  end
  
end
