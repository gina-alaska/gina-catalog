class Manager::CollectionsController < ManagerController
  before_filter :authenticate_access_catalog!

  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Collections'
  
  def index
    @catalog_collections = current_setup.collections.order('name ASC')

    respond_to do |format|
      format.html
      format.json { render json: @catalog_collection }
    end
  end

  def show
    @catalog_collection = current_setup.collections.find(params[:id])
  end

  def new
    @catalog_collection = current_setup.collections.build
  end

  def create
    @catalog_collection = current_setup.collections.build(params[:collection])
    
    # @catalog_collection = CatalogCollection.new(params[:catalog_collection])
    # current_setup.catalog_collections << @catalog_collection

    respond_to do |format|
      if @catalog_collection.save
        flash[:success] = 'Collection was successfully created.'
        format.html { redirect_to manager_collections_path }
      else
        format.html { render action: "new" }
        format.json { render json: @catalog_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @catalog_collection = current_setup.collections.find(params[:id])
    @records = @catalog_collection.catalogs.active
  end

  def update
    @catalog_collection = current_setup.collections.find(params[:id])

    respond_to do |format|
      if @catalog_collection.update_attributes(params[:collection])
        flash[:success] = "Collection #{@catalog_collection.name} was successfully updated."
        format.html { redirect_to manager_collections_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @catalog_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @catalog_collection = current_setup.collections.find(params[:id])
    @catalog_collection.destroy

    respond_to do |format|
      flash[:success] = 'Collection was successfully deleted.'
      format.html { redirect_to manager_collections_path }
      format.json { head :no_content }
    end
  end
  

  def add
    @catalog_collection = current_setup.collections.includes(:catalogs).find(params[:id])
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
    @catalog_collection = Collection.find(params[:id])
    @catalog_records = Catalog.where(id: params[:catalog_ids]).all
    @catalog_collection.catalogs.destroy(@catalog_records)

    respond_to do |format|
      format.js
    end
  end
end
