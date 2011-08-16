class LocationsController < ApplicationController
  respond_to :json

  def index
    @item = Catalog.find_by_id(params[:catalog_id])

    respond_with(@item.locations)
  end
end
