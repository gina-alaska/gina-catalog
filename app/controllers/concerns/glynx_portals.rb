module GlynxPortals
  extend ActiveSupport::Concern

  included do
    helper_method :current_portal
  end

  def current_portal
    @current_portal ||= load_current_portal
  end

  def load_current_portal
    PortalUrl.where(url: request.host).first.try(:portal)
  end

  def check_current_portal
    redirect_to portal_not_found_path if current_portal.nil?
  end
end
