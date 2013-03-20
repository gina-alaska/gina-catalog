class ManagerController < ApplicationController
  before_filter :authenticate_manager!
  
  before_filter :fetch_setup
  before_filter :fetch_manager_pages
  
  def dashboard
  end
  
  protected
  
  def fetch_manager_pages
    @manager_pages = { :page_contents => 'Pages', :page_snippets => 'Snippets', :page_layouts => 'Layouts', :setups => 'Settings' }
  end

  def authenticate_manager!
    unless user_is_a_member? and current_member.permissions.has_any?(:manage_catalog, :manage_cms, :manage_site)
      authenticate_user!
    end      
  end
  
  def authenticate_manage_catalog!
    unless user_is_a_member? and current_member.access_catalog?
      authenticate_user!
    end      
  end
  
  def authenticate_manage_cms!
    unless user_is_a_member? and current_member.can_manage_cms?
      authenticate_user!
    end      
  end
  
  def authenticate_manage_site!
    unless user_is_a_member? and current_member.can_manage_site?
      authenticate_user!
    end      
  end
  
  def authenticate_manage_members!
    unless user_is_a_member? and current_member.can_manage_members?
      authenticate_user!
    end      
  end
end
