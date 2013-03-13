class Manager::CatalogCollectionsController < ManagerController
  before_filter :authenticate_manage_catalog!

  def index
    @catalog_collections = current_setup.catalog_collections

    respond_to do |format|
      format.html
      format.json { render json: @catalog_collection }
    end
  end

  def show
    @catalog_collection = current_setup.catalog_collections.find(params[:id])
  end

  def new
    @catalog_collection = current_setup.catalog_collections.build
  end

  def create
    @catalog_collection = CatalogCollection.new(params[:catalog_collection])
    current_setup.catalog_collections << @catalog_collection

    respond_to do |format|
      if @catalog_collection.save
        flash[:success] = 'Collection was successfully created.'
        format.html { redirect_to manager_catalog_collections_path }
      else
        format.html { render action: "new" }
        format.json { render json: @catalog_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @catalog_collection = current_setup.catalog_collections.find(params[:id])
  end

  def update
    @catalog_collection = current_setup.catalog_collections.find(params[:id])

    respond_to do |format|
      if @catalog_collection.update_attributes(params[:catalog_collection])
        flash[:success] = "Collection #{@catalog_collection.name} was successfully updated."
        format.html { redirect_to manager_catalog_collections_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @catalog_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @catalog_collection = current_setup.catalog_collections.find(params[:id])
    @catalog_collection.destroy

    respond_to do |format|
      flash[:success] = 'Collection was successfully deleted.'
      format.html { redirect_to manager_catalog_collections_path }
      format.json { head :no_content }
    end
  end
  

  def add
    @catalog_collection = current_setup.catalog_collections.includes(:catalogs).find(params[:id])
    @catalog_collection.catalogs << Catalog.where(id: params[:catalog_ids])

    respond_to do |format|
      format.html {
        if request.xhr?
          render :nothing => true
        end
      }
    end
  end

  def remove
    @catalog_collection = CatalogCollection.find(params[:id])
    @catalog_records = Catalog.where(id: params[:catalog_ids])
    @catalog_collection.catalogs.delete(@catalog_records)

    respond_to do |format|
      format.js
    end
  end
end
