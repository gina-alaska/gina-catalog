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
      session[:return_to] = request.fullpath

      flash[:error] = 'You need to sign in before accessing this page!'
      redirect_to signin_path
    end
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
