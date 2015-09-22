class Catalog::AttachmentsController < ManagerController
  ATTACHMENTS_TO_LOG = ['Public Download', 'Private Download']

  load_and_authorize_resource find_by: :uuid

  def show
    response.headers['Access-Control-Allow-Origin'] = '*'

    @attachment = Attachment.where(uuid: params[:id]).first
    if ATTACHMENTS_TO_LOG.include?(@attachment.category)
      download_log = DownloadLog.new(user_agent: request.user_agent, user: current_user, entry: @attachment.entry, file_name: @attachment.file_name, portal: current_portal)
      download_log.save
    end

    respond_to do |format|
      format.js
      format.any { send_file @attachment.file.path, filename: @attachment.file.name }
    end
  end
end
