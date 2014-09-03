class WelcomeController < ApplicationController
  skip_before_action :check_current_site, only: [:site_not_found]
  
  def index
    
  end
  
  def site_not_found
  end
end
