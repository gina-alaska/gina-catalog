class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers
  include GlynxSites
  
  before_action :check_current_site
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to main_app.root_url, :alert => exception.message
    else
      session[:redirect_back_to] = request.original_url
      redirect_to login_path
    end
  end
end
