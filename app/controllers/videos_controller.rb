class VideosController < ApplicationController
  respond_to :html

  def show
    @video = Video.find_by_name(params[:id])

    respond_with(@video)
  end
end
