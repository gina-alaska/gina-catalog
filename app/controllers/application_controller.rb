class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers
  include GlynxPortals
  
  before_action :check_current_portal
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      render template: 'gina_authentication/permission_denied', status: :forbidden
    else
      session[:redirect_back_to] = request.original_url
      redirect_to login_path
    end
  end
  
  protected
  
  def current_ability
    @current_ability ||= Ability.new(current_user, current_portal)    
  end
end
