class Catalog::CollectionsController < CatalogController
  load_and_authorize_resource

  def index
    @q = Collection.ransack(params[:q])
    @q.sorts = 'position asc' if @q.sorts.empty?
    @collections = @q.result(distinct: true).page(params[:page])
    @collections = @collections.used_by_portal(current_portal) unless params[:all].present?

    respond_to do |format|
      format.html
      format.json { render json: @collections }
    end
  end

  #  def show
  #  end

  def new
    @collection = Collection.new
  end

  def edit
    save_referrer_location
  end

  def create
    @collection = Collection.new(collection_params)
    current_portal.collections << @collection

    respond_to do |format|
      if @collection.save
        flash[:success] = "Collection #{@collection.name} was successfully created."
        format.html { redirect_to catalog_collections_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @collection.update_attributes(collection_params)
        flash[:success] = "Collection #{@collection.name} was successfully updated."
        format.html { redirect_to catalog_collections_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    save_referrer_location
    @collection.destroy

    respond_to do |format|
      flash[:success] = "Collection #{@collection.name} was successfully deleted."
      format.html { redirect_to catalog_collections_path }
      format.json { head :no_content }
    end
  end

  def up
    @collection.move_higher

    respond_to do |format|
      format.html { redirect_to catalog_collections_path }
      format.js { redirect_to catalog_collections_path }
    end
  end

  def down
    @collection.move_lower

    respond_to do |format|
      format.html { redirect_to catalog_collections_path }
      format.js { redirect_to catalog_collections_path }
    end
  end

  def top
    @collection.move_to_top

    respond_to do |format|
      format.html { redirect_to catalog_collections_path }
      format.js { redirect_to catalog_collections_path }
    end
  end

  def bottom
    @collection.move_to_bottom

    respond_to do |format|
      format.html { redirect_to catalog_collections_path }
      format.js { redirect_to catalog_collections_path }
    end
  end

  protected

  def collection_params
    params.require(:collection).permit(:name, :description, :hidden)
  end
end
