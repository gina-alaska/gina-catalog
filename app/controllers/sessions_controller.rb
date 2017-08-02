class SessionsController < ApplicationController
  protect_from_forgery except: %i[create failure]
  include GinaAuthentication::Sessions
  skip_before_action :check_current_portal

  def new
    session[:redirect_back_to] = request.referer if session[:redirect_back_to].nil?
    redirect_to '/auth/gina'
  end
end
