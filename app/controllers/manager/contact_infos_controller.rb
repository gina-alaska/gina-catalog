class Manager::ContactInfosController < ManagerController

  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Download Log'

  def index
    @contact_infos = ContactInfo.joins(:catalog => [:catalogs_setups]).where(:catalogs_setups => { :setup_id => current_setup.id }).uniq

    do_contact_setup

    respond_to do |format|
      format.html
      format.json { render json: @contact_infos }
      format.csv { do_csv_download }
    end
  end

  def full_contact
    @contact_infos = ContactInfo.includes(:catalog => [:catalogs_setups]).where(:catalogs_setups => { :setup_id => current_setup.id })
    @contact_infos = @contact_infos.where("length(name) > 0 OR length(email) > 0")

    do_contact_setup

    respond_to do |format|
      format.html
      format.json { render json: @contact_infos }
      format.csv { do_csv_download }
    end
  end

  protected

  def do_contact_setup
    @page = params["page"].nil? ? 1 : params["page"]
    @limit = params["limit"].nil? ? 30 : params["limit"]
    @start_date = params["start_date"].present? ? Time.zone.parse(params["start_date"]) : 30.days.ago
    @end_date = params["end_date"].present? ? Time.zone.parse(params["end_date"]) : Time.zone.now

    if params["agency"].present?
      @contact_infos = @contact_infos.where("catalog.source_agency_id = ?", params["agency"])
    end

    @contact_infos = @contact_infos.created_between(@start_date, @end_date)
    @total = @contact_infos.count
    @contact_infos = @contact_infos.order("contact_infos.created_at DESC").page(@page).per(@limit)
  end

  def do_csv_download
    filename = "catalog-#{Time.now.strftime("%Y%m%d")}.csv"
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      # headers['Pragma'] = 'public'
      headers["Content-type"] = "text/csv" 
      # headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      # headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end
    render layout: false
  end
end
