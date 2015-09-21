class Catalog::AttachmentsController < ManagerController
  before_action :set_attachment
  authorize_resource

  def show
    respond_to do |format|
      format.geojson { send_file @attachment.file.path, filename: @attachment.file.name }
    end
  end

  protected

  def set_attachment
    @attachment = Attachment.where(uuid: params[:id]).first if params[:id].present?
  end
end
