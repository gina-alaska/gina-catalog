class Manager::AgenciesController < ApplicationController
  load_and_authorize_resource

  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html
      format.json { render json: @agencies }
    end
  end

  #def show
  #end

  def new
    @agency = Agency.new
    @agency.aliases.build
  end

  def edit
  end

  def create
    @agency = Agency.new(agency_params)
    # TODO: make sure that agencies do not need to be associated with sites. 

    respond_to do |format|
      if @agency.save
        flash[:success] = "Agency #{@agency.name} was successfully created."
        format.html { redirect_to manager_agencies_path }
      else
        format.html { render action: "new" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  protected
  
  def agency_params
    params.require(:agency).permit(:name, :acronym, :description, :category, :url, :active, :logo, aliases_attributes: [:text, :_destroy])
  end
end
