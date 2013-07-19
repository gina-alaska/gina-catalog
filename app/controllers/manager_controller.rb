class ManagerController < ApplicationController
  before_filter :authenticate_manager!
  
  before_filter :fetch_setup
    
  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Home'

  def dashboard
    @start_date = params["start_date"].present? ? Time.zone.parse(params["start_date"]) : 30.days.ago
    @end_date = params["end_date"].present? ? Time.zone.parse(params["end_date"]) : Time.zone.now

    if params["commit"] == "Clear"
      @start_date = nil
      @end_date = nil
    end

    @contact_infos = ContactInfo.joins(:catalog => [:catalogs_setups]).where(:catalogs_setups => { :setup_id => current_setup.id }).uniq

    if params["agency"].present?
      @contact_infos = @contact_infos.where("catalog.source_agency_id = ?", params["agency"])
    end
    
    @top_downloads = @contact_infos.select("contact_infos.catalog_id, count(*) as download_count").created_between(@start_date, @end_date).group("contact_infos.catalog_id")
    @top_downloads = @top_downloads.order('download_count DESC').limit(10) 
    
    @latest_access = @contact_infos.created_between(@start_date, @end_date).order('contact_infos.created_at DESC')    
    @latest_access = @latest_access.limit(50)    


    @stats = {
      :total_downloads => {
        :alltime =>  @contact_infos.count,
        :daterange => @contact_infos.created_between(@start_date, @end_date).count
      },
      :unique_downloads => {
        :alltime => @contact_infos.pluck(:catalog_id).uniq.count,
        :daterange => @contact_infos.created_between(@start_date, @end_date).pluck(:catalog_id).uniq.count    
      }
    }
  end

  protected
  
  def fetch_cms_pages
    @manager_pages = { 
      :page_contents => 'Pages', :page_snippets => 'Snippets', :page_layouts => 'Layouts', 
      :setups => 'Settings', :themes => 'Themes' } 
    @available_themes = Theme.where('owner_setup_id IS NULL or owner_setup_id = ?', current_setup.id)     
  end

  def authenticate_manager!
    unless user_is_a_member? and (current_member.access_catalog? or current_member.access_cms? or current_member.access_permissions?)
      authenticate_user!
    end      
  end
  
  def authenticate_access_catalog!
    unless user_is_a_member? and current_member.access_catalog?
      authenticate_user!
    end      
  end
  
  def authenticate_access_cms!
    unless user_is_a_member? and current_member.access_cms?
      authenticate_user!
    end      
  end
  
  def authenticate_access_permissions!
    unless user_is_a_member? and current_member.access_permissions?
      authenticate_user!
    end      
  end
end
