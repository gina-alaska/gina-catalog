class SdsAdminController < ApplicationController
	before_filter :authenticate_sds_manager!
  
  def index
  end
end
