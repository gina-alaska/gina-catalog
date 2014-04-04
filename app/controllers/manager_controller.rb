class ManagerController < ApplicationController
  include CatalogConcerns::Security  
  
  before_filter :authenticate_manager!
  
  before_filter :fetch_setup
    
  SUBMENU = '/layouts/manager/dashboard_menu'
  PAGETITLE = 'Home'

  def dashboard
    @start_date = params["start_date"].present? ? Time.zone.parse(params["start_date"]) : 30.days.ago
    @end_date = params["end_date"].present? ? Time.zone.parse(params["end_date"]) : Time.zone.now

    @downloads = current_setup.downloads
    @filtered_downloads = @downloads.where(created_at: (@start_date..@end_date))
    @top_downloads = @filtered_downloads.top

    @stats = {
      :total_downloads => {
        :alltime =>  @downloads.count,
        :daterange => @filtered_downloads.count
      },
      :unique_downloads => {
        :alltime => @downloads.pluck(:loggable_id).uniq.count,
        :daterange => @filtered_downloads.pluck(:loggable_id).uniq.count    
      }
    }
  end

  def links
    @bad_links = Link.where(valid_link: false, asset_type: 'Catalog').order("last_checked_at DESC").paginate(page: params[:page], per_page: 30)
  end

  protected
  
  def fetch_cms_pages
    @manager_pages = { 
      :page_contents => 'Pages', :page_snippets => 'Snippets', :page_layouts => 'Layouts', :themes => 'Themes' }
    @available_themes = Theme.where('owner_setup_id IS NULL or owner_setup_id = ?', current_setup.id)     
  end

  def page_title
    @page_title ||= PAGETITLE
  end

  def page_title=(title)
    @page_title = title
  end

  helper_method :page_title
end
