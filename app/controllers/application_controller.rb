class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  #protect_from_forgery

  protected

  def authorized?
    logged_in? && current_user.authorized?
  end

  def authorization_required
    authorized? || access_denied
  end

  def admin_required
    (logged_in? && current_user.is_an_admin?) || access_denied
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
      end
      format.json do
        render :json => {
          :success => false,
          :flash => "Permission Denied"
        }, :status => 403
      end
    end
  end
end
