class ManagerController < ApplicationController
	before_filter :authenticate_manager!
	
  def index
  end
end
