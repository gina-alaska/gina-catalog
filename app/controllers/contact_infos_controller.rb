class ContactInfosController < ApplicationController
  def create
    @item = Catalog.find(params[:catalog_id])
    
    @contact_info = ContactInfo.new(info_params)
    @contact_info.catalog = @item
    
    respond_to do |format|
      if @contact_info.save || !@item.require_contact_info?
        format.json { render json: { success: true } }
      else
        format.json { render json: { success: false, msg: @contact_info.errors.full_messages } }
      end
    end
  end
  
  protected
  
  def info_params
    params[:info].slice(:name, :email, :phone_number, :usage_description)
  end
end
