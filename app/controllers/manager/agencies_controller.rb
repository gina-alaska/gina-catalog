class Manager::AgenciesController < ManagerController

  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html
      format.json { render json: @catalog_collection }
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
    end
  end
end
