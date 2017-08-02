class Cms::ThemesController < CmsController
  before_action :set_cms_theme, only: %i[show edit update destroy activate]
  authorize_resource

  # GET /cms/themes
  # GET /cms/themes.json
  def index
    @cms_themes = current_portal.themes
  end

  # GET /cms/themes/new
  def new
    @cms_theme = current_portal.themes.build
  end

  # GET /cms/themes/1/edit
  def edit; end

  def activate
    if current_portal.update_attributes(active_cms_theme: @cms_theme)
      flash[:notice] = "#{@cms_theme} theme is now active"
    else
      flash[:error] = "Unable to activate #{@cms_theme}"
    end

    respond_to do |format|
      format.html { redirect_to cms_themes_path }
      format.js { redirect_via_turbolinks cms_themes_path }
    end
  end

  # POST /cms/themes
  # POST /cms/themes.json
  def create
    @cms_theme = current_portal.themes.build(cms_theme_params)

    respond_to do |format|
      if @cms_theme.save
        format.html { redirect_to cms_themes_path, notice: "Theme #{@cms_theme.name} was successfully created." }
        format.json { render :index, status: :created, location: @cms_theme }
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
        format.html { redirect_to cms_themes_path, notice: "Theme #{@cms_theme.name} was successfully updated." }
        format.json { render :index, status: :ok, location: @cms_theme }
      else
        format.html { render :edit }
        format.json { render json: @cms_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/themes/1
  # DELETE /cms/themes/1.json
  def destroy
    tname = @cms_theme.name
    @cms_theme.destroy
    respond_to do |format|
      format.html { redirect_to cms_themes_url, notice: "Theme #{tname} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cms_theme
    @cms_theme = current_portal.themes.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cms_theme_params
    params.require(:cms_theme).permit(:portal_id, :name, :css)
  end
end
