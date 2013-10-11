class Manager::MapLayersController < ManagerController  
  before_filter :authenticate_access_catalog!, except: [:share]
#  before_filter :authenticate_access_cms!
  before_filter :authenticate_edit_records!, only: [:edit, :new, :create, :update]
  
  respond_to :json, :js, :html
  
  def new
    @catalog = Catalog.find(params[:catalog_id])
    @map_layer = @catalog.map_layers.build
    
    respond_with(@map_layer)
  end
  
  def create
    @catalog = Catalog.find(params[:catalog_id])
    @map_layer = @catalog.map_layers.build(map_layer_params)
    
    respond_to do |wants|
      if @map_layer.save
        flash[:notice] = 'Map layer was successfully created.'
        wants.html { redirect_to(@map_layer) }
        wants.js
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
      if @map_layer.save
        flash[:notice] = 'Map layer was successfully updated.'
        wants.html { redirect_to(@map_layer) }
        wants.js
      else
        wants.html { render :action => "edit" }
        wants.js { render :action => "edit" }
      end
    end
  end
  
  
  protected
  
  def map_layer_params
    params[:map_layer].dup.slice(:name, :url, :layers, :projections, :type)
  end
end
