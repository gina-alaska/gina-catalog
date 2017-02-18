class Manager::DashboardsController < ManagerController
  authorize_resource class: false

  def index
    @user_count = current_portal.users.count
    @entry_count = current_portal.entries.count
    @top_downloads = current_portal.download_logs.top(:entry_id, 50)
    @download_count = current_portal.download_logs.count
    @download_unique_count = current_portal.download_logs.select(:file_name).uniq.count
    @cms_page_count = current_portal.pages.count
    @cms_attachment_count = current_portal.cms_attachments.count
  end

  def show
    @entry = Entry.find(params[:id])
    @downloads = @entry.download_logs.order('created_at DESC').limit(50)
  end

  def downloads
    @q = DownloadLog.ransack(params[:q])
    @q.sorts = 'created_at DESC' if @q.sorts.empty?
    @downloads = @q.result(distinct: true).page(params[:page]).per(100)

    respond_to do |format|
      format.html
      format.json { render json: @downloads }
    end
  end

  def links
    @q = Link.where(valid_link: false).ransack(params[:q])
    @q.sorts = 'primary_organization.name asc' if @q.sorts.empty?
    @links = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @downloads }
    end
  end
end
