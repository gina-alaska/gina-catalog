class Manager::ContactInfosController < ManagerController

  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Download Log'

  def index
    @contact_infos = ContactInfo
    @page = params["page"].nil? ? 1 : params["page"]
    @limit = params["limit"].nil? ? 30 : params["limit"]
    @start_date = params["start_date"]
    @end_date = params["end_date"]

    @contact_infos = @contact_infos.created_between(@start_date, @end_date)
    @total = @contact_infos.count
    @contact_infos = @contact_infos.order("created_at DESC").page(@page).per(@limit)

    respond_to do |format|
      format.html
      format.json { render json: @contact_infos }
    end
  end
end
