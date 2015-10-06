class Manager::DashboardsController < ManagerController
  authorize_resource class: false

  def index
    @user_count = current_portal.users.count
    @entry_count = current_portal.entries.count
    @top_downloads = current_portal.download_logs.top(:entry_id, 10)
  end

  def show

  end

  def downloads
    @download_count = current_portal.download_logs.count
  end
end
