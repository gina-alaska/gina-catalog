class AttachmentsController < ApplicationController
  def show
    response.headers['Access-Control-Allow-Origin'] = '*'

    @attachment = Attachment.where(uuid: params[:id]).first

    respond_to do |format|
      # format.geojson { send_data @attachment.file.data }
      format.any { send_file @attachment.file.path, filename: @attachment.file.name }
    end
  end
end
