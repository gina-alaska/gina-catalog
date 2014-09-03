module GlynxSites
  def current_site
    @current_site ||= load_current_site
  end
  
  def load_current_site
    SiteUrl.where(url: request.host).first.try(:site)
  end
  
  def check_current_site
    redirect_to site_not_found_path if current_site.nil?
  end
end