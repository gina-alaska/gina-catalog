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
    @activities = PublicActivity::Activity.where(entry_id: @entry.id).order(created_at: :desc)
    
    respond_to do |format|
      format.html
      format.geojson
    end
  end
end
