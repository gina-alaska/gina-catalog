class SdsController < ApplicationController
  # before_filter :redirect_to_next_step, :except => [:index, :reset, :update]
  before_filter :fetch_catalog
  
  def show
    redirect_to_next_step
  end
  
  def reset
    cookies.signed[:sds_catalog_id] = nil
    cookies.signed[:use_agreement_id] = nil
    cookies.signed[:contact_info_id] = nil
    redirect_to secure_data_path
  end
  
  def use_agreement
    redirect_to_next_step(STEP[:use_agreement]) unless ask_for_use_agreement?
  end
  
  def contactinfo
    redirect_to_next_step(STEP[:contact_info]) unless ask_for_contact_info?
    
    @contact_info = contact_info_from_cookie
    @contact_info ||= ContactInfo.new
  end
  
  def download
    redirect_to_next_step unless validate_step(STEP[:use_agreement]) and validate_step(STEP[:contact_info])
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
    case next_step(current)
    when STEP[:use_agreement]
      if ask_for_use_agreement? and request.path != use_agreement_secure_datum_path(@catalog)
        redirect_to use_agreement_secure_datum_path(@catalog) 
      end
    when STEP[:contact_info]
      if ask_for_contact_info? and request.path != contactinfo_secure_datum_path(@catalog)
        redirect_to contactinfo_secure_datum_path(@catalog)
      end
    when STEP[:download]
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
      cookies.signed[:sds_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = @contact_info.id
      redirect_to_next_step STEP[:contact_info]    
    else
      flash[:error] = 'Error while saving contact information'
      render 'contactinfo'
    end
  end
  
  def save_use_agreement
    @catalog = fetch_catalog
    
    cookies.signed[:sds_catalog_id] = @catalog.id
    cookies.signed[:use_agreement_id] = @catalog.use_agreement_id
    redirect_to_next_step STEP[:use_agreement]  
  end
  
  def contact_info_from_cookie
    ContactInfo.find(cookies.signed[:contact_info_id]) if cookies.signed[:contact_info_id]
  end
  
  def validate_step(step)
    return false if cookies.signed[:sds_catalog_id] != @catalog.id
    
    case step
    when STEP[:use_agreement]
      ask_for_use_agreement? ? cookies.signed[:use_agreement_id] : true
    when STEP[:contact_info]
      ask_for_contact_info? ? cookies.signed[:contact_info_id] : true
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
    return nil if params[:id].nil?
    
    d = DownloadUrl.where(uuid: params[:id]).first
    if d.nil?
      @catalog = Catalog.find(params[:id]) if params[:id]
    else
      @catalog = d.catalog
    end
  end
end
