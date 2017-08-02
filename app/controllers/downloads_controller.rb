class DownloadsController < ApplicationController
  ATTACHMENTS_TO_LOG = ['Public Download', 'Private Download'].freeze

  def show
    @download = GlobalID::Locator.locate_signed params[:id], for: 'download'
    authorize! :read, @download

    log_download

    respond_to do |format|
      format.any { send_file @download.file.path, filename: @download.file.name }
    end
  end

  def sds
    if (@download = Attachment.where(uuid: params[:id]).first).nil?
      # @download = Link.where() add later
    end

    respond_to do |format|
      format.html { redirect_to download_path(@download.global_id) }
    end
  end

  private

  def log_download
    return if @download.class != Attachment && !ATTACHMENTS_TO_LOG.include?(@download.category)
    download_log = DownloadLog.new(user_agent: request.user_agent, user: current_user, entry: @download.entry, file_name: @download.file_name, portal: current_portal)
    download_log.save
  end
end
