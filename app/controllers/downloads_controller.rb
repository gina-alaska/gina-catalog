class DownloadsController < ApplicationController
  layout 'downloads'
  
  def show
    @catalog = fetch_catalog
    
    respond_to do |format|
      if @catalog.downloadable?
        if @catalog.sds?
          # format.html {
          #   flash[:notice] = "Secure downloads are currently offline"
          #   redirect_to catalog_path(@catalog)
          # }
          format.html {
            render_next_sds_step            
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
    cookies.signed[:sds_step] = nil
  end

  def use_agreement
    if ask_for_use_agreement?
      render 'use_agreement'
    else
      render_next_sds_step(STEP[:use_agreement]) 
    end
  end

  def contact_info
    if ask_for_contact_info?
      @contact_info = contact_info_from_cookie
      @contact_info ||= ContactInfo.new
      
      render 'contact_info'
    else
      render_next_sds_step(STEP[:contact_info]) 
    end
    # render_next_sds_step(STEP[:contact_info]) unless ask_for_contact_info?
  
    # @contact_info = contact_info_from_cookie
    # @contact_info ||= ContactInfo.new
  end

  def download
    if validate_step(STEP[:use_agreement]) and validate_step(STEP[:contact_info])
      reset
      if @catalog.remote_download?
        @authorized = true
        render 'use_agreement'
      else
        offer_file
      end
    else
      flash[:error] = "Please complete all the download steps"
      redirect_to catalog_download_path(@catalog)
    end
  end

  def next
    @catalog = fetch_catalog
    
    if params.include? :contact_info
      save_contact_info
    elsif params.include? :use_agreement
      save_use_agreement
    else
      redirect_to catalog_download_path(@catalog)
    end
  end
  
  protected
  
  def offer_file
    if @catalog.local_download?
      send_file @catalog.repo.archive_filenames[:zip]
    else
      render 'public/404', :status => 404
    end
  end
  
  STEP = { :use_agreement => 1, :contact_info => 2, :download => 3 }
  
  def render_next_sds_step(current = cookies.signed[:sds_step])
    unless validate_step(current)
      reset 
      current = 0
    end
      
    current ||= 0
    
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

  def save_contact_info
    info_params = params[:contact_info].slice(:name, :email, :phone_number, :usage_description)
    @contact_info = ContactInfo.new(info_params)
    @contact_info.catalog = @catalog
  
    if @contact_info.save(validate: @catalog.require_contact_info)
      cookies.signed[:sds_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = @contact_info.id
      render_next_sds_step STEP[:contact_info]    
    else
      render 'contact_info' 
    end
  end

  def save_use_agreement
    cookies.signed[:sds_catalog_id] = @catalog.id
    cookies.signed[:use_agreement_id] = @catalog.use_agreement_id
    cookies.signed[:sds_step] = STEP[:use_agreement]
    
    # render_next_sds_step STEP[:use_agreement]  
    redirect_to catalog_download_path(@catalog)
  end

  def contact_info_from_cookie
    ContactInfo.find(cookies.signed[:contact_info_id]) if cookies.signed[:contact_info_id]
  end

  def validate_step(step)
    return false if cookies.signed[:sds_catalog_id] != @catalog.id
  
    case step
    when STEP[:use_agreement]
      ask_for_use_agreement? and cookies.signed[:use_agreement_id] ? true : false
    when STEP[:contact_info]
      ask_for_contact_info? and cookies.signed[:contact_info_id] ? true : false
    else
      false
    end
  end

  def next_step(current)
    return STEP[:use_agreement] if current < STEP[:use_agreement] and ask_for_use_agreement?
    return STEP[:contact_info] if current < STEP[:contact_info] and ask_for_contact_info?
    return STEP[:download] 
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
