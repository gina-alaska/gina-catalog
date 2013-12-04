class DownloadsController < ApplicationController
  layout 'downloads'
  STEP = { :use_agreement => 1, :contact_info => 2, :download => 3 }
  
  def index
    @catalog = fetch_catalog
    unless cookies.signed[:sds_catalog_id] == @catalog.id
      reset
    end
    
    respond_to do |format|
      if @catalog.downloadable?
        if @catalog.sds? or @catalog.remote_download?
          # format.html {
          #   flash[:notice] = "Secure downloads are currently offline"
          #   redirect_to catalog_path(@catalog)
          # }
          format.html {
            if @catalog.local_download? and params[:offer] == 'true' and authorized?
              offer_file
            else
              render_next_sds_step            
            end
          }
          format.js { reset }
        else
          format.html { offer_file }
          format.js { reset }
        end
      else
        flash[:error] = "#{@catalog.title} is not available for download"
        format.html { redirect_to catalog_path(@catalog) }
        format.js { reset }
      end
    end
  end
  
  def reset
    cookies.signed[:sds_catalog_id] = nil
    cookies.signed[:use_agreement_id] = nil
    cookies.signed[:contact_info_id] = nil
    cookies.signed[:sds_step] = 0
  end

  def use_agreement
    unless @catalog.require_contact_info?
    #   save_contact_info
      @authorized = true 
    end
    
    # if ask_for_use_agreement?
    render 'use_agreement'
    # else
      # render_next_sds_step(STEP[:use_agreement]) 
    # end
  end

  def contact_info
    @catalog ||= fetch_catalog
    
    if ask_for_contact_info?
      # save_contact_info
      @contact_info = contact_info_from_cookie || ContactInfo.new
      render 'contact_info'
    else
      render_next_sds_step(STEP[:contact_info]) 
    end
  end

  def download
    save_contact_info
    
    # reset
    if @catalog.remote_download?
      @authorized = true
      render 'use_agreement'
    else
      offer_file
    end
  end
  
  def show
    @catalog = fetch_catalog
    @download = @catalog.download_urls.where(uuid: params[:id]).first

    save_contact_info
    redirect_to @download.url
  end

  def next
    @catalog = fetch_catalog
    
    if params.include? :contact_info
      if save_contact_info(true)
        render_next_sds_step STEP[:contact_info]    
      else
        render 'contact_info' 
      end
    elsif params.include? :use_agreement
      save_use_agreement
      redirect_to catalog_downloads_path(@catalog)
    else
      redirect_to catalog_downloads_path(@catalog)
    end
  end
  
  protected
  
  def authorized?
    return true unless @catalog.require_contact_info? or ask_for_use_agreement?
    
    return false if @catalog.require_contact_info? and cookies.signed[:contact_info_id].nil?
    # return false if ask_for_use_agreement? and cookies.signed[:use_agreement_id].nil?
    
    return true
  end
  
  def offer_file
    if @catalog.local_download?
      save_contact_info
      send_file @catalog.archive_file
    else
      render 'public/404', :status => 404
    end
  end
  
  def render_next_sds_step(current = cookies.signed[:sds_step])    
    case next_step(current)
    when STEP[:use_agreement]
      use_agreement
    when STEP[:contact_info]
      contact_info
    when STEP[:download]
      download
    end
  end

  def ask_for_use_agreement?
    @catalog.use_agreement #and not cookies.signed[:use_agreement_id] == @catalog.use_agreement_id
  end

  # make sure we didn't already ask them for their info, but also check to make sure
  # it was for the current catalog item
  def ask_for_contact_info?
    @catalog.request_contact_info or @catalog.require_contact_info
  end

  def save_contact_info(run_validations = false)
    info_params = params[:contact_info].try(:slice, :name, :email, :phone_number, :usage_description)

    @contact_info = contact_info_from_cookie || ContactInfo.new
    @contact_info.attributes = info_params unless info_params.nil?
    @contact_info.catalog = @catalog
  
    # Add more information
    @contact_info.user_ip = request.remote_ip
    @contact_info.user_agent = request.env['HTTP_USER_AGENT']
    @contact_info.user_id = current_user.id unless current_user.nil?
    @contact_info.setup_id = current_setup.id
    
    if @contact_info.save(validate: (run_validations and @catalog.require_contact_info))
      cookies.signed[:sds_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = @contact_info.id
      return true
    else
      return false
    end
  end

  def save_use_agreement
    cookies.signed[:sds_catalog_id] = @catalog.id
    cookies.signed[:use_agreement_id] = @catalog.use_agreement_id
    cookies.signed[:sds_step] = STEP[:use_agreement]    
  end

  def contact_info_from_cookie
    ContactInfo.find(cookies.signed[:contact_info_id]) if cookies.signed[:contact_info_id]
  end

  def validate_step(step)
    return false if cookies.signed[:sds_catalog_id] and cookies.signed[:sds_catalog_id] != @catalog.id
  
    case step
    when STEP[:use_agreement]
      ask_for_use_agreement? and cookies.signed[:use_agreement_id] ? true : false
    when STEP[:contact_info]
      ask_for_contact_info? and cookies.signed[:contact_info_id] ? true : false
    else
      false
    end
  end

  def next_step(current = 0)
    current = 0 if current.nil?
    
    return STEP[:use_agreement] if current < STEP[:use_agreement]
    return STEP[:contact_info] if current < STEP[:contact_info] and ask_for_contact_info?
    return STEP[:download] 
  end
  
  def fetch_download_url
    DownloadUrl.where(uuid: params[:catalog_id]).first
  end
  
  def fetch_catalog
    return nil if params[:catalog_id].nil?
  
    d = DownloadUrl.where(uuid: params[:catalog_id]).first
    if d.nil?
      @catalog = Catalog.find(params[:catalog_id]) if params[:catalog_id]
    else
      @catalog = d.catalog
    end
  end
end
