class SdsAdminController < ApplicationController
	before_filter :authenticate_sds_manager!
  
  def index
    @top_downloads = ContactInfo.select("catalog_id, count(*) as download_count").group("catalog_id")
    @top_downloads = @top_downloads.order('download_count DESC').limit(10) 
    
    @latest_access = ContactInfo.where('created_at < ?', 1.month.ago).order('created_at DESC')
    
    @total_downloads = ContactInfo
    
    unless current_user.is_an_admin?
      @top_downloads = @top_downloads.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
      @latest_access = @latest_access.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
      @total_downloads = @total_downloads.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency_id })
    end
  end
end
