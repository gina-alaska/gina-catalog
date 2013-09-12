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
    @csw_import = current_setup.csw_imports.where(id: params[:id]).first
    @log = @csw_import.activity_logs.where(id: params[:log]).first || @csw_import.activity_logs.first
    @unknown_agencies = @log.unknown_agencies

    respond_to do |format|
      format.html
      format.js
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
    @csw_import = current_setup.csw_imports.find(params[:id])
    @csw_import.destroy

    respond_to do |format|
      flash[:success] = 'CSW Import was successfully deleted.'
      format.html { redirect_to manager_csw_imports_path }
      format.json { head :no_content }
    end
  end
  
  def import
    @csw_import = current_setup.csw_imports.where(id: params[:id]).first
    Resque.enqueue(CswImportWorker, @csw_import.id)
  end
  
  def new_agency
    save_url
    redirect_to new_manager_agency_path(new_agency_params)
  end
  
  def agencies
    # @csw_import = current_setup.csw_imports.where(id: params[:id]).first
  #   @agencies = []
  #   client = RCSW::Client::Base.new(@csw_import.url)
  #   records = client.record(client.records.collect(&:identifier))
  #   records.each do |record|
  #     metadata = FGDC.new(@csw_import.fgdc_import_url(record))
  #     unless metadata.source_agency.nil? and Agency.where(name: metadata.source_agency).any?
  #       @agencies << metadata.source_agency
  #     end
  #   end
  #   @agencies.uniq!.flatten!
  end
  
  private
  def new_agency_params
    params.slice(:name, :acronym, :description, :category) || {}
  end
end
