class ManagerController < ApplicationController
  before_filter :authenticate_manager!
  
  before_filter :fetch_setup
  before_filter :fetch_manager_pages
  
  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Home'

  def dashboard
    @top_downloads = ContactInfo.select("catalog_id, count(*) as download_count").group("catalog_id")
    @top_downloads = @top_downloads.order('download_count DESC').limit(10) 
    
    @latest_access = ContactInfo.where('contact_infos.created_at > ?', 1.month.ago).order('contact_infos.created_at DESC').limit(50)
    
    @total_downloads = ContactInfo
    
    unless current_user.is_an_admin?
      @top_downloads = @top_downloads.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
      @latest_access = @latest_access.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
      @total_downloads = @total_downloads.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
    end
  end
  
  protected
  
  def fetch_manager_pages
    @manager_pages = { :page_contents => 'Pages', :page_snippets => 'Snippets', :page_layouts => 'Layouts', :setups => 'Settings' }
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
