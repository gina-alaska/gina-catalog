class Manager::ContactInfosController < ManagerController

  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Download Log'

  def index
    @contact_infos = ContactInfo.joins(:catalog => [:catalogs_setups]).where(:catalogs_setups => { :setup_id => current_setup.id }).uniq
    @page = params["page"].nil? ? 1 : params["page"]
    @limit = params["limit"].nil? ? 30 : params["limit"]
    @start_date = params["start_date"].present? ? Time.zone.parse(params["start_date"]) : 30.days.ago
    @end_date = params["end_date"].present? ? Time.zone.parse(params["end_date"]) : Time.zone.now

    @contact_infos = @contact_infos.created_between(@start_date, @end_date)
    @total = @contact_infos.count
    @contact_infos = @contact_infos.order("created_at DESC").page(@page).per(@limit)

    respond_to do |format|
      format.html
      format.json { render json: @contact_infos }
    end
  end
end
