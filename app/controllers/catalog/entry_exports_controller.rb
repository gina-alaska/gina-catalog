class Catalog::EntryExportsController < CatalogController
  before_action :set_entry_export, only: [:show, :edit, :update, :destroy, :download]
  include EntriesControllerSearchConcerns

  # GET /entry_exports
  # GET /entry_exports.json
  def index
    @entry_exports = EntryExport.all
  end

  # GET /entry_exports/1
  # GET /entry_exports/1.json
  def show
    @export_params = @entry_export.attributes
  end

  # GET /entry_exports/new
  def new
    @entry_export = EntryExport.new
  end

  # GET /entry_exports/1/edit
  def edit
  end

  # POST /entry_exports
  # POST /entry_exports.json
  def create
    @entry_export = EntryExport.new(entry_export_params)

    respond_to do |format|
      if @entry_export.save
        format.html { redirect_to [:catalog, @entry_export], notice: 'Entry export was successfully created.' }
        format.json { render :show, status: :created, location: @entry_export }
      else
        format.html { render :new }
        format.json { render json: @entry_export.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entry_exports/1
  # PATCH/PUT /entry_exports/1.json
  def update
    respond_to do |format|
      if @entry_export.update(entry_export_params)
        format.html { redirect_to [:catalog, @entry_export], notice: 'Entry export was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry_export }
      else
        format.html { render :edit }
        format.json { render json: @entry_export.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_exports/1
  # DELETE /entry_exports/1.json
  def destroy
    @entry_export.destroy
    respond_to do |format|
      format.html { redirect_to entry_exports_url, notice: 'Entry export was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    #params = @entry_export.attributes
    #@search_params = params["serialized_search"]
    @search_params = @entry_export.serialized_search.symbolize_keys
    logger.info '*' * 20
    logger.info @search_params

    @search_results = search(params[:page], params[:limit] || 500)
    logger.info '*' * 20
    logger.info @search_results.inspect
    
    respond_to do |format|
      format.html
      format.geojson
      format.json
      format.csv {
        csv_string = render_to_string
        send_data(csv_string, disposition: :attachment)
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_export
      @entry_export = EntryExport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_export_params
      export_params = params.require(:entry_export).permit(:serialized_search, :organizations, :collections, :contacts, :data, :description, :info, :iso, :links, :location, :tags, :title, :url, :limit, :description_chars, :format_type)

      export_params[:serialized_search] = JSON.parse(export_params[:serialized_search]).symbolize_keys

      export_params
    end
end
