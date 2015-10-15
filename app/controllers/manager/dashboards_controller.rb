class Manager::DashboardsController < ManagerController
  authorize_resource class: false

  def index
    @user_count = current_portal.users.count
    @entry_count = current_portal.entries.count
    @top_downloads = current_portal.download_logs.top(:entry_id, 10)
    @download_count = current_portal.download_logs.count
    @download_unique_count = current_portal.download_logs.select(:file_name).uniq.count
    @cms_page_count = current_portal.pages.count
    @cms_attachment_count = current_portal.cms_attachments.count
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def downloads
    # @downloads = DownloadLog.where(entry_id: current_portal.entry_ids)

    @q = DownloadLog.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @downloads = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @downloads }
    end
  end

  def links
    @links = Link.where(entry_id: current_portal.entries.pluck(:id))
  end
end
