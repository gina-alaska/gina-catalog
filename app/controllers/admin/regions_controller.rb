class Admin::RegionsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @region.save
        flash[:success] = "Region #{@region.name} was created."
        format.html { redirect_to admin_regions_path }
      else
        format.html { render action: "new" }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  protected
  
  def region_params
    params.require(:region).permit(:name, :geojson)
  end
end
