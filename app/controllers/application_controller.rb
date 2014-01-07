class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_for_setup
  before_filter :fetch_setup
  
  helper_method :current_user
  helper_method :current_member
  helper_method :user_signed_in?
  helper_method :current_setup
  helper_method :current_notifications

  protected
  
  def fetch_setup
    @current_setup ||= Setup.includes(:urls).where(site_urls: { :url => request.host }).first    
  end
  alias_method :current_setup, :fetch_setup

  def check_for_setup
    redirect_to "http://portal.gina.alaska.edu" if current_setup.nil?
  end

  def member_portals(permission = nil)
    return [] unless user_signed_in?
    # .sort {|a,b| a.try(:title).to_s <=> b.try(:title).to_s }
    @member_portals ||= {}
    @member_portals[:all] ||= current_user.setups.order('title ASC')
    
    if permission.nil?
      return @member_portals[:all]
    else
      @member_portals[permission.to_sym] ||= @member_portals[:all].reject do |p|
        !current_user.memberships.where(setup_id: p.id).first.send(permission)
      end
      return @member_portals[permission.to_sym]
    end
  end
  helper_method :member_portals
  
  private  
  
  def current_user  
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
  end
  
  def current_member
    @current_member ||= current_user.memberships.where(setup_id: current_setup).includes(:setup, :roles, :permissions).first || Membership.new(user: current_user, setup: current_setup) if user_signed_in?
  end
  
  def current_notifications
    if @current_notifications.nil?
      @current_notifications = Notification.global_or_local_to(current_setup).where("expire_date > ?", Time.zone.now)
      @current_notifications = @current_notifications.where("id not in (?)", Array.wrap(session["read_notifications"])) if session["read_notifications"].present?
    end
    @current_notifications
  end

  def user_signed_in?
    return true if current_user 
  end
  
  def user_is_a_member?
    return true if user_signed_in? and current_user.is_an_admin?
    return true if user_signed_in? and current_member
  end
    
  def authenticate_user!
    if !current_user
      session[:return_to] = request.fullpath

      flash[:error] = 'You must sign in before accessing this page!'
      redirect_to signin_path
    else
      flash[:error] = 'You do not have permission to access this page'
      redirect_to root_url
    end
  end 
  
  def authenticate_sds_manager!
    if !current_user || !(current_user.is_an_admin? || current_user.is_a_sds_manager?)
      authenticate_user!
    end      
  end

  def authenticate_admin!
    if !current_user || !current_user.is_an_admin?
      authenticate_user!
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
