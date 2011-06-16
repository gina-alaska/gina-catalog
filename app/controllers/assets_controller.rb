class AssetsController < ApplicationController
  def show
    @asset = Asset.find(params[:id])

    render :layout => false
  end
end
