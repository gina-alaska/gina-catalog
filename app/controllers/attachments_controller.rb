class AttachmentsController < ApplicationController
  def show
    response.headers["Access-Control-Allow-Origin"] = '*'

    @attachment = Attachment.where(uuid: params[:id]).first

    respond_to do |format|
      format.geojson { send_data @attachment.file.data }
    end
  end
end
