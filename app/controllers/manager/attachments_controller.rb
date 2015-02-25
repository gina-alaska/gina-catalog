class Manager::AttachmentsController < ApplicationController
  load_and_authorize_resource

  def show
    respond_to do |format|
      format.geojson { send_data @attachment.file.data }
      format.js
    end
  end

  def map
  end
end
