class WelcomeController < ApplicationController
  skip_before_action :check_current_portal, only: [:portal_not_found]

  def index; end

  def portal_not_found
    redirect_to root_url unless current_portal.nil?
  end

  def permission_denied
    render status: :forbidden
  end
end
