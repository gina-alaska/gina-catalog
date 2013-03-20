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
    unless user_is_a_member? and (current_member.access_catalog? or current_member.access_cms? or current_member.access_permissions?)
      authenticate_user!
    end      
  end
  
  def authenticate_access_catalog!
    unless user_is_a_member? and current_member.access_catalog?
      authenticate_user!
    end      
  end
  
  def authenticate_access_cms!
    unless user_is_a_member? and current_member.access_cms?
      authenticate_user!
    end      
  end
  
  def authenticate_access_permissions!
    unless user_is_a_member? and current_member.access_permissions?
      authenticate_user!
    end      
  end
end
