class Cms::LayoutsController < CmsController
  before_action :set_cms_layout, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /cms/layouts
  # GET /cms/layouts.json
  def index
    @cms_layouts = current_portal.layouts
  end

  # GET /cms/layouts/new
  def new
    @cms_layout = current_portal.layouts.build
  end

  # GET /cms/layouts/1/edit
  def edit
  end

  # POST /cms/layouts
  # POST /cms/layouts.json
  def create
    @cms_layout = current_portal.layouts.build(cms_layout_params)

    respond_to do |format|
      if @cms_layout.save
        format.html { redirect_to cms_layouts_path, notice: 'Layout was successfully created.' }
        format.json { render :show, status: :created, location: @cms_layout }
      else
        format.html { render :new }
        format.json { render json: @cms_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/layouts/1
  # PATCH/PUT /cms/layouts/1.json
  def update
    respond_to do |format|
      if @cms_layout.update(cms_layout_params)
        format.html { redirect_to cms_layouts_path, notice: 'Layout was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_layout }
      else
        format.html { render :edit }
        format.json { render json: @cms_layout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/layouts/1
  # DELETE /cms/layouts/1.json
  def destroy
    respond_to do |format|
      if @cms_layout.pages.size > 0
        format.html { redirect_to cms_layouts_url, notice: 'Cannot delete layout that is attached to a page' }
        format.json { head :no_content }
      else
        @cms_layout.destroy
        format.html { redirect_to cms_layouts_url, notice: 'Layout was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_layout
      @cms_layout = current_portal.layouts.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_layout_params
      params.require(:cms_layout).permit(:name, :portal_id, :content)
    end
end
