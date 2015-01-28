class WelcomeController < ApplicationController
  skip_before_action :check_current_portal, only: [:portal_not_found]

  def index
  end

  def portal_not_found
    unless current_portal.nil?
      redirect_to root_url
    end
  end
end
