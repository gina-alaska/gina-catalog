class DownloadsController < ApplicationController
  layout 'downloads'
  def offer
    if params[:key].present? and params[:key] == current_contact_info.offer_key
      current_contact_info.activity_logs.record_download!(current_download, current_user, current_setup)
      redirect_to current_download.url
    else
      flash[:error] = 'Could not start download, the download key was invalid'
      redirect_to catalog_download_path(current_catalog, current_download)
    end
  end

  def contact_info
    if !ask_for_contact_info?
      redirect_to catalog_download_path(current_catalog, current_download)
    end
  end
  
  def sds
    @download = fetch_download_url
    
    if @download.catalog.require_contact_info? or @download.catalog.request_contact_info?
      redirect_to edit_catalog_download_path(@download.catalog, @download)
    else
      redirect_to catalog_download_path(@download.catalog, @download)
    end
  end

  def show
    respond_to do |format|
      format.html {
        unless save_contact_info
          redirect_to edit_catalog_download_path(current_catalog, current_download)
        end          
      }
      format.js
    end
  end
  
  def edit
  end
  
  def update
    if save_contact_info
      redirect_to catalog_download_path(current_catalog, current_download)
    else
      render 'edit'
    end
  end
  
  protected
  
  def reset
    cookies.signed[:contact_info_id] = nil
  end
  
  def ask_for_contact_info?
    current_catalog.request_contact_info or current_catalog.require_contact_info
  end
  
  def current_contact_info
    @contact_info ||= contact_info_from_cookie || ContactInfo.new
  end
  
  def current_catalog
    @catalog ||= fetch_catalog
  end
  
  def current_download
    # look for local upload file
    @download ||= current_catalog.uploads.where(uuid: params[:id]).first
    # if not found then look for remote file
    @download ||= current_catalog.download_urls.where(uuid: params[:id]).first
    
    @download
  end
  helper_method :current_download, :current_catalog, :current_contact_info
  
  def authorized?
    return true unless current_catalog.require_contact_info? or ask_for_use_agreement?
    
    return false if current_catalog.require_contact_info? and cookies.signed[:contact_info_id].nil?
    # return false if ask_for_use_agreement? and cookies.signed[:use_agreement_id].nil?
    
    return true
  end

  def save_contact_info(run_validations = false)
    info_params = params[:contact_info].try(:slice, :name, :email, :phone_number, :usage_description)

    #different catalog record
    if !current_contact_info.catalog.nil? and current_catalog.id != current_contact_info.catalog.id
      @contact_info = ContactInfo.new
    end
    current_contact_info.attributes = info_params unless info_params.nil?
    current_contact_info.catalog = current_catalog
  
    # Add more information
    current_contact_info.user_ip = request.remote_ip
    current_contact_info.user_agent = request.env['HTTP_USER_AGENT']
    current_contact_info.user_id = current_user.id unless current_user.nil?
    current_contact_info.setup_id = current_setup.id
    
    current_contact_info.save(validate: false)
    cookies.signed[:contact_info_id] = current_contact_info.id
    
    if current_catalog.require_contact_info and !current_contact_info.valid?
      return false 
    else
      return true
    end
  end

  def contact_info_from_cookie
    @contact_info ||= ContactInfo.where(id: cookies.signed[:contact_info_id], catalog_id: current_catalog.id).first 
  end
  
  def fetch_download_url
    DownloadUrl.where(uuid: params[:catalog_id]).first
  end
  
  def fetch_catalog
    return nil if params[:catalog_id].nil?
  
    d = DownloadUrl.where(uuid: params[:catalog_id]).first
    if d.nil?
      current_catalog = Catalog.find(params[:catalog_id]) if params[:catalog_id]
    else
      current_catalog = d.catalog
    end
  end
end
