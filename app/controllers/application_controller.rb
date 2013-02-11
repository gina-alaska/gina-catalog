class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :fetch_setup
  
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :current_setup

  protected
  
  def fetch_setup
    @setup = Setup.includes(:urls).where(site_urls: { :url => request.host }).first
    
    if @setup.nil? 
      redirect_to new_manager_setup_path
    end
  end

  alias_method :current_setup, :fetch_setup

  private  
  
  def current_user  
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
  end
  
  def user_signed_in?
    return true if current_user 
  end
    
  def authenticate_user!
    if !current_user
      session[:return_to] = request.fullpath

      flash[:error] = 'You must sign in before accessing this page!'
      redirect_to signin_path
    end
  end 

  def authenticate_manager!
    if !current_user || !(current_user.is_an_admin? || current_user.is_a_manager?)
      if !current_user
        authenticate_user!
      else
        flash[:error] = 'You do not have permission to access this page'
        redirect_to root_url
      end
    end      
  end
  
  def authenticate_sds_manager!
    if !current_user || !(current_user.is_an_admin? || current_user.is_a_sds_manager?)
      if !current_user
        authenticate_user!
      else
        flash[:error] = 'You do not have permission to access this page'
        redirect_to root_url
      end
    end      
  end

  def authenticate_admin!
    if !current_user || !(current_user.is_an_admin?)
      if !current_user
        authenticate_user!
      else
        flash[:error] = 'You do not have permission to access this page'
        redirect_to root_url
      end
    end      
  end
  
  def save_url(url = nil)
    session[:return_to] = url || request.fullpath
  end

  def redirect_back_or_default(default = '/')
    if session[:return_to]
      path = session[:return_to]
      session[:return_to] = nil
      redirect_to path
    else
      redirect_to default
    end
  end
end
