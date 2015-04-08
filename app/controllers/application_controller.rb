require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include GinaAuthentication::AppHelpers
  include GlynxPortals

  before_action :check_current_portal

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_exception|
    if signed_in?
      # flash.now[:error] = 'You do not have permission to view this page'
      render template: 'welcome/permission_denied', status: :forbidden
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
