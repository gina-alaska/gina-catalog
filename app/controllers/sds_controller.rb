class SdsController < ApplicationController
  before_filter :redirect_to_next_step, :except => [:reset, :update]
  
  def show
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
    @contact_info = ContactInfo.new
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
  
  def redirect_to_next_step
    @catalog = fetch_catalog
    
    logger.info !contact_info_cookie
    
    if ask_for_use_agreement?
      unless request.path == use_agreement_secure_datum_path(@catalog)
        redirect_to use_agreement_secure_datum_path(@catalog) 
      end
    elsif ask_for_contact_info?
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
    @catalog.use_agreement and not cookies.signed[:use_agreement_id] == @catalog.use_agreement_id
  end
  
  # make sure we didn't already ask them for their info, but also check to make sure
  # it was for the current catalog item
  def ask_for_contact_info?
    (@catalog.request_contact_info or @catalog.require_contact_info) and 
    (!contact_info_cookie or cookies.signed[:contact_info_catalog_id] != @catalog.id)
  end
  
  def save_contact_info
    @catalog = fetch_catalog
    
    info_params = params[:contact_info].slice(:name, :email, :phone_number, :usage_description)
    @contact_info = ContactInfo.new(info_params)
    @contact_info.catalog = @catalog
    
    if @contact_info.save
      cookies.signed[:contact_info_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = @contact_info.id
      redirect_to_next_step      
    elsif !@catalog.require_contact_info
      cookies.signed[:contact_info_catalog_id] = @catalog.id
      cookies.signed[:contact_info_id] = true
      redirect_to_next_step      
    else
      flash[:error] = 'Error while saving contact information'
      render 'contactinfo'
    end
  end
  
  def save_use_agreement
    @catalog = fetch_catalog
    
    cookies.signed[:use_agreement_id] = @catalog.use_agreement_id
    redirect_to_next_step      
  end
  
  def contact_info_cookie
    ContactInfo.find(cookies.signed[:contact_info_id]) if cookies.signed[:contact_info_id]
  end
  
  def fetch_catalog
    d = DownloadUrl.where(uuid: params[:id]).first
    if d.nil?
      Catalog.find(params[:id]) if params[:id]
    else
      d.catalog
    end
  end
end
