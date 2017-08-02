class Admin::RegionsController < AdminController
  load_and_authorize_resource

  def index; end

  def show
    respond_to do |format|
      format.geojson
    end
  end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      if @region.save
        flash[:success] = "Region #{@region.name} was created."
        format.html { redirect_to admin_regions_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @region.update_attributes(region_params)
        flash[:success] = "Region #{@region.name} was updated."
        format.html { redirect_to admin_regions_path }
      else
        format.html { render action: 'edit' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @region.destroy
        flash[:success] = "Region #{@region.name} was successfully deleted."
        format.html { redirect_to admin_regions_path }
        format.json { head :no_content }
      else
        flash[:error] = @region.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to admin_regions_path }
      end
    end
  end

  protected

  def region_params
    params.require(:region).permit(:name, :geojson)
  end
end
