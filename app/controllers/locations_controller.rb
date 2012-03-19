class LocationsController < ApplicationController
  respond_to :json

  def index
    @item = Catalog.find_by_id(params[:catalog_id])

    respond_with(@item.locations)
  end
  
  def destroy
    respond_to do |format|
      format.json { 
        render :json => { :success => Location.destroy(params[:id]) }
      }
    end
  end
end
