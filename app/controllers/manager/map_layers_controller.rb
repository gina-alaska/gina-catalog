class Manager::MapLayersController < ManagerController  
  before_filter :authenticate_access_catalog!, except: [:share]
#  before_filter :authenticate_access_cms!
  before_filter :authenticate_edit_records!, only: [:edit, :new, :create, :update]
  
  respond_to :json, :js, :html
  
  def index
    @catalog = Catalog.find(params[:catalog_id])
    
    @map_layers = @catalog.map_layers
    
    respond_to do |wants|
      wants.html { render :layout => false if request.xhr? }
    end
  end
  
  def new
    @catalog = Catalog.find(params[:catalog_id])
    case params[:layer_type]
    when 'WMS'
      @map_layer = WmsLayer.new     
    when 'TILE'
      @map_layer = TileLayer.new     
    when 'ARC'
      @map_layer = ArcLayer.new     
    end

    respond_with(@map_layer)
  end
  
  def create
    @catalog = Catalog.find(params[:catalog_id])

    @map_layer = @catalog.map_layers.build(map_layer_params)
    @map_layer = @map_layer.becomes(@map_layer.type.constantize)

    respond_to do |wants|
      if @map_layer.save
        flash[:notice] = 'Map layer was successfully created.'
        wants.html { edit_manager_catalog_path(@catalog) }
        wants.js { render nothing: true }
        # wants.json { render :json => @map_layer, status: :created, :location => @map_layer }
      else
        wants.html { render :action => "new" }
        wants.js { render :action => "new" }
      end
    end
  end
  
  def edit
    @catalog = Catalog.find(params[:catalog_id])
    @map_layer = @catalog.map_layers.find(params[:id])
    
    respond_with(@map_layer)
  end

  def update
    @catalog = Catalog.find(params[:catalog_id])
    @map_layer = @catalog.map_layers.find(params[:id])
            
    respond_to do |wants|
      if @map_layer.update_attributes(map_layer_params)
        flash[:notice] = 'Map layer was successfully updated.'
        wants.html { redirect_to edit_manager_catalog_path(@catalog) }
        wants.js { render nothing: true }
      else
        wants.html { render :action => "edit" }
        wants.js { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @catalog = Catalog.find(params[:catalog_id])
    @map_layer = @catalog.map_layers.find(params[:id])

    respond_to do |wants|
      if @map_layer.destroy
        flash[:notice] = "#{@map_layer.name} has been deleted"
        wants.html { redirect_to edit_manager_catalog_path(@catalog) }
        wants.js { render nothing: true }
      else
      end
    end
  end
  
  protected
  
  def map_layer_params
    params[:map_layer].dup.slice(:name, :url, :layers, :projections, :type)
  end
end
