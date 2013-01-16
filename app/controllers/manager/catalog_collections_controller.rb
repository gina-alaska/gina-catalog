class Manager::CatalogCollectionsController < ManagerController
  
  def index
    @catalog_collection = CatalogCollection.all

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @catalog_collection = CatalogCollection.where(id: params[:id]).first
  end

  def new
    @catalog_collection = CatalogCollection.new
  end

  def create
    @catalog_collection = CatalogCollection.new(params[:catalog_collection])

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
    @catalog_collection = CatalogCollection.where(id: params[:id]).first
  end

  def update
    @catalog_collection = CatalogCollection.where(id: params[:id]).first

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
    @catalog_collection = CatalogCollection.where(id: params[:id]).first
    @catalog_collection.destroy

    respond_to do |format|
      flash[:success] = 'Collection was successfully deleted.'
      format.html { redirect_to manager_catalog_collections_path }
      format.json { head :no_content }
    end
  end

end
