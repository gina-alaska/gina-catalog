class Api::IsoTopicsController < ApplicationController
  def index
    @iso_topics = IsoTopic.where('name ilike :query or iso_theme_code ilike :query or long_name ilike :query', query: "%#{search_params}%")
    @iso_topics = @iso_topics.order(iso_theme_code: :asc).all

    respond_to do |format|
      format.json
    end
  end

  protected

  def search_params
    params[:q].present? ? params[:q] : ''
  end
end
