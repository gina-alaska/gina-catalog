class AttachmentsController < ApplicationController
  ATTACHMENTS_TO_LOG = ['Public Download', 'Private Download'].freeze

  def show
    response.headers['Access-Control-Allow-Origin'] = '*'

    @attachment = Attachment.where(uuid: params[:id]).first
    if ATTACHMENTS_TO_LOG.include?(@attachment.category)
      query_params = {
        user_agent: request.user_agent,
        user: current_user,
        entry: @attachment.entry,
        file_name: @attachment.file_name,
        portal: current_portal
      }

      download_log = DownloadLog.new(query_params)
      download_log.save
    end

    respond_to do |format|
      # format.geojson { send_data @attachment.file.data }
      format.any { send_file @attachment.file.path, filename: @attachment.file.name }
    end
  end
end
