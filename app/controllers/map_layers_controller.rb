class MapLayersController < ApplicationController
  respond_to :json
  
  def show
    @map_layer = MapLayer.find(params[:id])
    
    respond_with(@map_layer)
  end
end
