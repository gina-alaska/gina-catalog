class Api::MapLayersController < ApplicationController
  def index
    @map_layers = MapLayer.search(
      search_params,
      fields: [
        { 'name^2' => :word_start },
        { type: :word_start },
        { map_url: :word_start }
      ]
    )

    respond_to do |format|
      format.json
    end
  end

  protected

  def search_params
    params[:query].present? ? params[:query] : '*'
  end
end
