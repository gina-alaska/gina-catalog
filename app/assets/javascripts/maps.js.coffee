class CatalogMap
  constructor: (@el) ->
    @btnHandlers = {}
    
    @setupMap(@el)
    @setupToolbar()
    
    $(@el).data('map', this)
  # end constructor
  
  addBtnHandler: (name, func) =>
    @btnHandlers[name] = func
  #end addBtnHandler
  
  setupToolbar: ->
    @addBtnHandler('zoomToMaxExtent', @zoomToDefaultBounds)
      
    @btns = $(@el).find('.navbar a.btn')
    @btns.on 'click', (evt) =>
      evt.preventDefault()  
      action = $(evt.currentTarget).data('action')
      if @btnHandlers[action]
        @btnHandlers[action]()
  # end setupToolbar
  
  setupMap: (el) ->
    @data_config = $(el).data()
    @config = Gina.Projections.get('EPSG:3338');
    @config['projection'] = @data_config['projection']
    @config['displayProjection'] = @data_config['displayProjection']
    
    @map = new OpenLayers.Map(@data_config['openlayers'], @config)
    console.log(@data_config['layers'])
    Gina.Layers.inject(@map, @data_config['layers']);
    # @zoomToDefaultBounds()
    @map.zoomToMaxExtent()
  #end setupMap
  
  zoomToDefaultBounds: =>
    bounds = new OpenLayers.Bounds(@config['bounds']);
    # @map.zoomToExtent(bounds , true);
    @map.zoomToMaxExtent()
  #end zoomToDefaultBounds  
#end CatalogMap

$(document).ready ->
  $('div[data-openlayers]').each -> 
    el = $(this).attr('id');
    new CatalogMap(this);