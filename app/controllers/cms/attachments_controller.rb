class Cms::AttachmentsController < CmsController
  before_action :set_cms_attachment, only: [:show, :edit, :update, :destroy]

  # GET /cms/attachments
  # GET /cms/attachments.json
  def index
    @cms_attachments = Cms::Attachment.all
  end

  # GET /cms/attachments/1
  # GET /cms/attachments/1.json
  def show
  end

  # GET /cms/attachments/new
  def new
    @cms_attachment = Cms::Attachment.new
  end

  # GET /cms/attachments/1/edit
  def edit
  end

  # POST /cms/attachments
  # POST /cms/attachments.json
  def create
    @cms_attachment = Cms::Attachment.new(cms_attachment_params)

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
      @cms_attachment = Cms::Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_attachment_params
      params.require(:cms_attachment).permit(:name, :description, :file)
    end
end
