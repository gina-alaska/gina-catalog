class SdsAdmin::ContactInfosController < SdsAdminController
  respond_to :html
  
  def index
    if false and current_user.admin?
      @contact_infos = ContactInfo
    elsif current_user.agency
      @contact_infos = ContactInfo.joins(:catalog).where(:catalog => { :source_agency_id => current_user.agency.id })
    end
    
    if @contact_infos.nil?
      @contact_infos = []
    else
      @contact_infos = @contact_infos.order('created_at DESC')
    end
    
    respond_with(@contact_infos)
  end
end
