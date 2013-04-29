class Manager::ContactInfosController < ManagerController

  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Download Log'

  def index
    @contact_infos = ContactInfo
    @page = params["page"].nil? ? 1 : params["page"]
    @limit = params["limit"].nil? ? 30 : params["limit"]
    @total = @contact_infos.count
    @start_date = params["start_date"]
    @end_date = params["end_date"]

    @end_date = Time.now.to_date if @end_date.blank? and !@start_date.blank?

    if @start_date.blank?
      @contact_infos = @contact_infos.order("created_at DESC").page(@page).per(@limit)
    else
      @contact_infos = @contact_infos.where("created_at >= ? AND created_at <= ?", @start_date, @end_date).order("created_at DESC").page(@page).per(@limit)
    end

    respond_to do |format|
      format.html
      format.json { render json: @contact_infos }
    end
  end
end
