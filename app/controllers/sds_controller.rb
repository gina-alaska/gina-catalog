class SdsController < ApplicationController
  # before_filter :redirect_to_next_step, :except => [:index, :reset, :update]
  before_filter :fetch_catalog
  
  def show
    redirect_to_next_step
  end
  
  def reset
    cookies.signed[:use_agreement_id] = nil
    cookies.signed[:contact_info_id] = nil
    cookies.signed[:contact_info_catalog_id] = nil
    redirect_to secure_data_path
  end
  
  def use_agreement
  end
  
  def contactinfo
    @contact_info = contact_info_from_cookie
    logger.info @contact_info.inspect
    @contact_info ||= ContactInfo.new
  end
  
  def download
  end
  
  def update
    respond_to do |format|
      format.html do
        if params.include? :contact_info
          save_contact_info
        elsif params.include? :use_agreement
          save_use_agreement
        end
      end
    end
  end
  
  protected
  
  STEP = { :use_agreement => 1, :contact_info => 2, :download => 3 }
  
  def redirect_to_next_step(current = 0)
    @catalog = fetch_catalog
    logger.info '************'
    logger.info "Current Step: #{current}"
    if current < STEP[:use_agreement] and ask_for_use_agreement?
      unless request.path == use_agreement_secure_datum_path(@catalog)
        redirect_to use_agreement_secure_datum_path(@catalog) 
      end
    elsif current < STEP[:contact_info] and ask_for_contact_info?
      unless request.path == contactinfo_secure_datum_path(@catalog)
        redirect_to contactinfo_secure_datum_path(@catalog)
      end
    else
      unless request.path == download_secure_datum_path(@catalog)
        redirect_to download_secure_datum_path(@catalog)
      end
    end
  end
  
  def ask_for_use_agreement?
    @catalog.use_agreement #and not cookies.signed[:use_agreement_id] == @catalog.use_agreement_id
  end
  
  # make sure we didn't already ask them for their info, but also check to make sure
  # it was for the current catalog item
  def ask_for_contact_info?
    (@catalog.request_contact_info or @catalog.require_contact_info) # and 
    #(!contact_info_cookie or cookies.signed[:contact_info_catalog_id] != @catalog.id)
  end
  
  def save_contact_info
    @catalog = fetch_catalog
    
    info_params = params[:contact_info].slice(:name, :email, :phone_number, :usage_description)
    @contact_info = ContactInfo.new(info_params)
    @contact_info.catalog = @catalog
    
    if @contact_info.save(validate: @catalog.require_contact_info)
      cookies.signed[:contact_info_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = @contact_info.id
      redirect_to_next_step STEP[:contact_info]     
    else
      flash[:error] = 'Error while saving contact information'
      render 'contactinfo'
    end
  end
  
  def save_use_agreement
    @catalog = fetch_catalog
    
    cookies.signed[:use_agreement_id] = @catalog.use_agreement_id
    redirect_to_next_step STEP[:use_agreement]   
  end
  
  def contact_info_from_cookie
    ContactInfo.find(cookies.signed[:contact_info_id]) if cookies.signed[:contact_info_id]
  end
  
  def fetch_catalog
    return nil if params[:id].nil?
    
    d = DownloadUrl.where(uuid: params[:id]).first
    if d.nil?
      @catalog = Catalog.find(params[:id]) if params[:id]
    else
      @catalog = d.catalog
    end
  end
end
