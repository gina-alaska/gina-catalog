class Api::IsoTopicsController < ApplicationController
  def index
    @iso_topics = IsoTopic.all.order(:name)
    @iso_topics = IsoTopic.search(
      search_params,
      fields: [
        { name: :word_start },
        { iso_theme_code: :word_start },
        { long_name: :word_start }
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
