class Cms::SnippetsController < CmsController
  before_action :set_cms_snippet, only: [:show, :edit, :update, :destroy]
  authorize_resource
  # GET /cms/snippets
  # GET /cms/snippets.json
  def index
    @cms_snippets = Cms::Snippet.all
  end

  # GET /cms/snippets/1
  # GET /cms/snippets/1.json
  def show
  end

  # GET /cms/snippets/new
  def new
    @cms_snippet = Cms::Snippet.new
  end

  # GET /cms/snippets/1/edit
  def edit
  end

  # POST /cms/snippets
  # POST /cms/snippets.json
  def create
    @cms_snippet = Cms::Snippet.new(cms_snippet_params)

    respond_to do |format|
      if @cms_snippet.save
        format.html { redirect_to @cms_snippet, notice: 'Snippet was successfully created.' }
        format.json { render :show, status: :created, location: @cms_snippet }
      else
        format.html { render :new }
        format.json { render json: @cms_snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/snippets/1
  # PATCH/PUT /cms/snippets/1.json
  def update
    respond_to do |format|
      if @cms_snippet.update(cms_snippet_params)
        format.html { redirect_to @cms_snippet, notice: 'Snippet was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_snippet }
      else
        format.html { render :edit }
        format.json { render json: @cms_snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/snippets/1
  # DELETE /cms/snippets/1.json
  def destroy
    @cms_snippet.destroy
    respond_to do |format|
      format.html { redirect_to cms_snippets_url, notice: 'Snippet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_snippet
      @cms_snippet = Cms::Snippet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_snippet_params
      params.require(:cms_snippet).permit(:name, :slug, :content, :portal_id)
    end
end
