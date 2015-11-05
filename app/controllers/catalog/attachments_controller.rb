class Catalog::AttachmentsController < CatalogController
  before_action :set_attachment
  authorize_resource

  def show
    respond_to do |format|
      format.geojson { send_file @attachment.file.path, filename: @attachment.file.name }
    end
  end

  def preview
    respond_to do |format|
      format.js
    end
  end

  protected

  def set_attachment
    @attachment = Attachment.geojson.where(uuid: params[:id]).first if params[:id].present?
  end
end
