class SdsAdmin::ContactInfosController < SdsAdminController
  def index
    @contact_infos = ContactInfo.all
  end
end
