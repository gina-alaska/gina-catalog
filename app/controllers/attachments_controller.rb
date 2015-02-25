class AttachmentsController < ApplicationController
  def show
    @attachment = Attachment.where(uuid: params[:id]).first

    respond_to do |format|
      format.geojson { send_data @attachment.file.data }
      format.js
    end
  end
end
