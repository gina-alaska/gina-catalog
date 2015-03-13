class EntriesController < ApplicationController
  load_and_authorize_resource

  def show
    @archive_item = ArchiveItem.new
    respond_to do |format|
      format.html
      format.geojson
    end
  end
end
