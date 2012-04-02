class ManagerController < ApplicationController
  before_filter :authorization_required
  
  def index
  end
end
