class Cms::AttachmentsController < CmsController
  before_action :set_cms_attachment, only: %i[show edit update destroy add remove]
  authorize_resource

  # GET /cms/attachments
  # GET /cms/attachments.json
  def index
    @cms_attachments = current_portal.cms_attachments

    @cms_attachments = sort_by(@cms_attachments, params[:sort]) if params[:sort]

    @cms_attachments = @cms_attachments.images if params[:images]
  end

  # GET /cms/attachments/1
  # GET /cms/attachments/1.json
  def show; end

  # GET /cms/attachments/new
  def new
    @cms_attachment = current_portal.cms_attachments.build
  end

  # GET /cms/attachments/1/edit
  def edit; end

  def remove
    @page = current_portal.pages.friendly.find(params[:page_id])
    @page.attachments.destroy(@cms_attachment)

    redirect_to :back
  end

  def add
    @page = current_portal.pages.friendly.find(params[:page_id])
    @page.attachments << @cms_attachment unless @page.attachments.include?(@cms_attachment)

    # redirect_to :back
    respond_to do |format|
      format.json do
        render json: { location: edit_cms_page_path(@page) }
      end
    end
  end

  def up
    @page = current_portal.pages.friendly.find(params[:page_id])
    @page_attachment = @page.cms_page_attachments.where(attachment_id: params[:id]).first
    @page_attachment.move_higher
    redirect_to :back
  end

  def down
    @page = current_portal.pages.friendly.find(params[:page_id])
    @page_attachment = @page.cms_page_attachments.where(attachment_id: params[:id]).first
    @page_attachment.move_lower
    redirect_to :back
  end

  # POST /cms/attachments
  # POST /cms/attachments.json
  def create
    @cms_attachment = current_portal.cms_attachments.build(cms_attachment_params)

    respond_to do |format|
      if @cms_attachment.save
        format.html { redirect_to @cms_attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @cms_attachment }
      else
        format.html { render :new }
        format.json { render json: @cms_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/attachments/1
  # PATCH/PUT /cms/attachments/1.json
  def update
    respond_to do |format|
      if @cms_attachment.update(cms_attachment_params)
        format.html { redirect_to @cms_attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_attachment }
      else
        format.html { render :edit }
        format.json { render json: @cms_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/attachments/1
  # DELETE /cms/attachments/1.json
  def destroy
    @cms_attachment.destroy
    respond_to do |format|
      format.html { redirect_to cms_attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cms_attachment
    @cms_attachment = current_portal.cms_attachments.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cms_attachment_params
    params.require(:cms_attachment).permit(:name, :description, :file)
  end

  def sort_by(collection, field = '')
    fields = {
      'name' => 'name',
      'filename' => 'file_filename',
      'age' => 'created_at',
      'size' => 'file_size',
      '' => 'name'
    }
    collection.order(fields[field] => :asc)
  end
end
