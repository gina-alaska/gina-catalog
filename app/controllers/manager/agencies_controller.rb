class Manager::AgenciesController < ManagerController
  load_and_authorize_resource

  def index
    @q = Agency.search(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @agencies = @q.result(distinct: true)
    @agencies = @agencies.used_by_portal(current_portal) unless params[:all].present?
      
    respond_to do |format|
      format.html
      format.json { render json: @agencies }
    end
  end

  #def show
  #end

  def search
    query = params[:query].split(/\s+/)
    @q = Agency.search(name_or_acronym_or_category_cont_any: query)
    @agencies = @q.result(distinct: true)
    
    render json: @agencies
  end

  def new
    @agency = Agency.new
    @agency.aliases.build
  end

  def edit
  end

  def create
    @agency = Agency.new(agency_params)
    # TODO: make sure that agencies do not need to be associated with portals. 

    respond_to do |format|
      if @agency.save
        flash[:success] = "Agency #{@agency.name} was successfully created."
        format.html { redirect_to manager_agency_path(@agency) }
      else
        format.html { render action: "new" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @agency.update_attributes(agency_params)
        flash[:success] = "Agency #{@agency.name} was successfully updated."
        format.html { redirect_to manager_agencies_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|    
      if @agency.destroy
        flash[:success] = "Agency #{@agency.name} was successfully deleted."
        format.html { redirect_to manager_agencies_path }
        format.json { head :no_content }     
      else
        flash[:error] = @agency.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to manager_agencies_path }
#        format.json { head :no_content } 
      end
    end
  end

  protected
  
  def agency_params
    params.require(:agency).permit(:name, :acronym, :description, :category, :url, :active, :logo, aliases_attributes: [:id, :text, :_destroy])
  end
end
