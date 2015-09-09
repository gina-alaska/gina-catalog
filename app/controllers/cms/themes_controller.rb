class Cms::ThemesController < CmsController
  before_action :set_cms_theme, only: [:show, :edit, :update, :destroy]

  # GET /cms/themes
  # GET /cms/themes.json
  def index
    @cms_themes = Cms::Theme.all
  end

  # GET /cms/themes/1
  # GET /cms/themes/1.json
  def show
  end

  # GET /cms/themes/new
  def new
    @cms_theme = Cms::Theme.new
  end

  # GET /cms/themes/1/edit
  def edit
  end

  # POST /cms/themes
  # POST /cms/themes.json
  def create
    @cms_theme = Cms::Theme.new(cms_theme_params)

    respond_to do |format|
      if @cms_theme.save
        format.html { redirect_to @cms_theme, notice: 'Theme was successfully created.' }
        format.json { render :show, status: :created, location: @cms_theme }
      else
        format.html { render :new }
        format.json { render json: @cms_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/themes/1
  # PATCH/PUT /cms/themes/1.json
  def update
    respond_to do |format|
      if @cms_theme.update(cms_theme_params)
        format.html { redirect_to @cms_theme, notice: 'Theme was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_theme }
      else
        format.html { render :edit }
        format.json { render json: @cms_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/themes/1
  # DELETE /cms/themes/1.json
  def destroy
    @cms_theme.destroy
    respond_to do |format|
      format.html { redirect_to cms_themes_url, notice: 'Theme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_theme
      @cms_theme = Cms::Theme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_theme_params
      params.require(:cms_theme).permit(:portal_id, :name, :css)
    end
end
