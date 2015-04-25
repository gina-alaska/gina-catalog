class Catalog::MapLayersController < ApplicationController
  load_and_authorize_resource
  respond_to :json, :js, :html

  def index
    @q = MapLayer.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @map_layers = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @map_layer }
    end
  end

  def search
    @map_layers = MapLayer.search(params[:query])

    respond_to do |format|
      format.json
    end
  end

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    case params[:map_layer][:type]
    when 'WmsLayer'
      @map_layer = WmsLayer.new(map_layer_params)
    end

    respond_to do |format|
      if @map_layer.save
        flash[:notice] = 'Map layer was successfully created.'
        format.html { redirect_to catalog_map_layers_path }
        format.js { render nothing: true }
      else
        format.html { render action: 'new' }
        format.js { render action: 'new' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @map_layer.update_attributes(map_layer_params)
        flash[:notice] = 'Map layer was successfully updated.'
        format.html { redirect_to catalog_map_layers_path }
        format.js { render nothing: true }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @map_layer.destroy
        flash[:notice] = "#{@map_layer.name} has been deleted"
        format.html { redirect_to catalog_map_layers_path }
        format.js
      else
        flash[:error] = @map_layer.errors.full_messages.join('<br />').html_safe
        format.html { redirect_back_or_default manager_entries_path }
      end
    end
  end

  protected

  def map_layer_params
    params.require(:map_layer).permit(:id, :name, :type, :map_url, :layers, :projections)
  end
end
