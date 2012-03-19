class LinksController < ApplicationController
  def destroy
    respond_to do |format|
      format.json { 
        render :json => { :success => Link.destroy(params[:id]) }
      }
    end
  end
end
