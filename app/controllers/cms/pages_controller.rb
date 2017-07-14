class Cms::PagesController < CmsController
  before_action :set_cms_page, only: [:show, :edit, :update, :destroy, :top, :bottom, :up, :down]
  authorize_resource

  # GET /cms/pages
  # GET /cms/pages.json
  def index
    @cms_pages = current_portal.pages
  end

  # GET /cms/pages/1
  # GET /cms/pages/1.json
  def show
  end

  # GET /cms/pages/new
  def new
    @cms_page = current_portal.pages.build
    @cms_layouts = current_portal.layouts
    if params[:parent]
      @cms_page.parent = @parent_page = current_portal.pages.friendly.find(params[:parent])
    end
    @cms_page.cms_layout = @cms_page.parent.try(:cms_layout) || current_portal.default_cms_layout
  end

  def reorder
  end

  def up
    @cms_page.siblings_before.last.try(:prepend_sibling, @cms_page)

    respond_to do |format|
      format.html { redirect_to reorder_cms_pages_path }
      format.js { redirect_to reorder_cms_pages_path }
    end
  end

  def down
    @cms_page.siblings_after.first.try(:append_sibling, @cms_page)

    respond_to do |format|
      format.html { redirect_to reorder_cms_pages_path }
      format.js { redirect_to reorder_cms_pages_path }
    end
  end

  def top
    @cms_page.siblings_before.first.try(:prepend_sibling, @cms_page)

    respond_to do |format|
      format.html { redirect_to reorder_cms_pages_path }
      format.js { redirect_to reorder_cms_pages_path }
    end
  end

  def bottom
    @cms_page.siblings_after.last.try(:append_sibling, @cms_page)

    respond_to do |format|
      format.html { redirect_to reorder_cms_pages_path }
      format.js { redirect_to reorder_cms_pages_path }
    end
  end

  # GET /cms/pages/1/edit
  def edit
    @cms_layouts = current_portal.layouts
  end

  # POST /cms/pages
  # POST /cms/pages.json
  def create
    @cms_page = current_portal.pages.build(cms_page_params)

    respond_to do |format|
      if @cms_page.save
        format.html { redirect_to @cms_page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @cms_page }
      else
        format.html { render :new }
        format.json { render json: @cms_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/pages/1
  # PATCH/PUT /cms/pages/1.json
  def update
    respond_to do |format|
      if @cms_page.update(cms_page_params)
        format.html { redirect_to @cms_page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_page }
      else
        format.html { render :edit }
        format.json { render json: @cms_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/pages/1
  # DELETE /cms/pages/1.json
  def destroy
    @cms_page.destroy
    respond_to do |format|
      format.html { redirect_to cms_pages_url, notice: "#{@cms_page.title} has been deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cms_page
    @cms_page = current_portal.pages.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cms_page_params
    params.require(:cms_page).permit(:title, :slug, :content, :cms_layout_id, :parent_id, :description, :hidden, :redirect_url, :draft)
  end
end
