class Manager::DashboardController < ManagerController
  def index
    @user_count = current_portal.users.count
    @entry_count = current_portal.entries.count
    @download_count = current_portal.download_logs.count
    @top_downloads = current_portal.download_logs
  end

  def downloads

  end
end
