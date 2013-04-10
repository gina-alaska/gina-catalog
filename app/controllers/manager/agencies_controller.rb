class Manager::AgenciesController < ManagerController
  before_filter :authenticate_access_catalog!
  
  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Agencies'
  
  def index
    page = params[:page] || 1
    limit = params["limit"].nil? ? 30 : params["limit"]
    limit = 30000 if limit == "all"
    @search = search_params

    search = Agency.search do
      fulltext search_params[:q] if search_params[:q]
      paginate per_page:(limit), page:(page)
    end

    @agencies = search.results

    respond_to do |format|
      format.html
      format.json { render json: @agencies }
    end
  end

  def show
    @agency = Agency.find(params[:id])
  end

  def new
    @agency = Agency.new
  end

  def create
    @agency = Agency.new(params[:agency])
    @agency.setups << current_setup

    if @agency.save!
      respond_to do |format|
        flash[:success] = "Agency #{@agency.name} was successfully created."
        format.html { redirect_to manager_agencies_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @agency = Agency.find(params[:id])
  end

  def update
    @agency = Agency.where(id: params[:id]).first

    if @agency.update_attributes(params[:agency])
      respond_to do |format|
        flash[:success] = "Agency #{@agency.name} was successfully updated."
        format.html { redirect_to manager_agencies_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy

    respond_to do |format|
      flash[:success] = "Agency #{@agency.name} was successfully deleted."
      format.html { redirect_to manager_agencies_path }
      format.json { head :no_content }
      format.js
    end
  end

  def visible
    @agencies = Agency.where(id: params[:agencies_ids])
    current_setup.agencies << @agencies

    respond_to do |format|
      format.html {
        redirect_to manager_agencies_path
      }
      format.js { render 'visible' }
    end
  end

  def hidden
    @agencies = Agency.where(id: params[:agencies_ids])
    current_setup.agencies.delete(@agencies)

    respond_to do |format|
      format.html {
        redirect_to manager_agencies_path
      }
      format.js { render 'visible' }
    end
  end

  protected

  def search_params
    params[:search] || {}
  end
end
