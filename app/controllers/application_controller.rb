class ApplicationController < ActionController::Base
  #protect_from_forgery

  helper_method :current_user
  helper_method :user_signed_in?

  private  
  def current_user  
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
  end
  
  def user_signed_in?
    return 1 if current_user 
  end
    
  def authenticate_user!
    if !current_user
      flash[:error] = 'You need to sign in before accessing this page!'
      redirect_to signin_services_path
    end
  end 

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
