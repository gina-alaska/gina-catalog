module GlynxSites
  def current_site
    @current_site ||= load_current_site
  end
  
  def load_current_site
    nil
  end
end