class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers
  include GlynxPortals

  before_action :check_current_portal

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Necessary include if you plan on access controller instance
  # in Procs passed to #tracked method in your models
  include PublicActivity::StoreController
  include ActionView::Helpers::TextHelper

  rescue_from CanCan::AccessDenied do |_exception|
    if signed_in?
      redirect_to permission_denied_path, status: :forbidden
    else
      session[:redirect_back_to] = request.original_url
      redirect_to login_path
    end
  end

  protected

  def owned_by_current_portal(entry)
    entry.owner_portal.id == current_portal.id
  end
  helper_method :owned_by_current_portal

  def current_ability
    controller_namespace = controller_path.split('/').first
    @current_ability ||= Ability.new(current_user, current_portal, controller_namespace)
  end
end
