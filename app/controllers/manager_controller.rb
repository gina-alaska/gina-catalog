class ManagerController < ApplicationController
  before_filter :authenticate_admin!
  before_filter :fetch_setup
  before_filter :fetch_manager_pages
  
  def dashboard
  end
  
  protected
  
  def fetch_manager_pages
    @manager_pages = { :pages => 'Pages', :page_layouts => 'Layouts', :setups => 'Settings' }
  end
end
