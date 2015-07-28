class EntriesController < ApplicationController
  load_and_authorize_resource

  include EntriesControllerSearchConcerns

  def index
    respond_to do |format|
      format.html { search(params[:page], params[:limit] || 20) }
      format.geojson { search(params[:page], params[:limit] || 500) }
      format.json
    end
  end

  def show
    @archive_item = ArchiveItem.new
    respond_to do |format|
      format.html
      format.geojson
    end
  end

  def map
    @entry  = Entry.find(params['entry_id'])

    respond_to do |format|
      format.html
      format.geojson
    end
  end
end
