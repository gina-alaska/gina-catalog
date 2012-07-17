class SdsController < ApplicationController
  before_filter :redirect_to_next_step, :except => [:reset, :update]
  
  def show
  end
  
  def reset
    cookies.signed[:use_agreement] = false
    cookies.signed[:contact_info] = false
    
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
    if @catalog.use_agreement and not cookies.signed[:use_agreement]
      unless request.path == use_agreement_secure_datum_path(@catalog)
        redirect_to use_agreement_secure_datum_path(@catalog) 
      end
    elsif (@catalog.request_contact_info or @catalog.require_contact_info) and contact_info_cookie.nil?
      unless request.path == contactinfo_secure_datum_path(@catalog)
        redirect_to contactinfo_secure_datum_path(@catalog)
      end
    else
      unless request.path == download_secure_datum_path(@catalog)
        redirect_to download_secure_datum_path(@catalog)
      end
    end
  end
  
  def save_contact_info
    @catalog = fetch_catalog
    
    info_params = params[:contact_info].slice(:name, :email, :phone_number, :usage_description)
    @contact_info = ContactInfo.new(info_params)
    @contact_info.catalog = @catalog
    
    if @contact_info.save
      cookies.signed[:contact_info] = @contact_info.id
      redirect_to_next_step      
    elsif !@catalog.require_contact_info
      cookies.signed[:contact_info] = true
      redirect_to_next_step      
    else
      flash[:error] = 'Error while saving contact information'
      render 'contactinfo'
    end
  end
  
  def save_use_agreement
    cookies.signed[:use_agreement] = true
    redirect_to_next_step      
  end
  
  def contact_info_cookie
    ContactInfo.find(cookies.signed[:contact_info]) if cookies.signed[:contact_info]
  end
  
  def fetch_catalog
    Catalog.find(params[:id]) if params[:id]
  end
end
