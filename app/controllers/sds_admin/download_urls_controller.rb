class SdsAdmin::DownloadUrlsController < ApplicationController
  before_filter :fetch_asset
  before_filter :fetch_download_url, :only => [:destroy]
  
  def destroy
    respond_to do |format|
      if @download_url.destroy
        format.html {
          flash[:success] = 'Deleted download url'
          redirect_to edit_sds_admin_asset_path(@asset)          
        }
      else
        format.html {
          flash[:error] = 'Error while trying to delete the download url'
          redirect_to edit_sds_admin_asset_path(@asset)
        }
      end
    end
  end
  
  protected
  
  def fetch_asset
    @asset = Asset.find(params[:asset_id]) if params[:asset_id]
  end
  
  def fetch_download_url
    @download_url = @asset.download_urls.find(params[:id]) if @asset && params[:id]
  end
end
