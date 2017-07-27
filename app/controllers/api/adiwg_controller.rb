class Api::AdiwgController < ApplicationController
  def show
    @entry = Entry.find(params[:id])
    
    respond_to do |format|
		format.json
	end
  end
end
