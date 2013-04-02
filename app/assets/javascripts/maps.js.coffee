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
      
    @btns = $(@el).find('.navbar a.btn, .navbar button.btn')
    @btns.on 'click', (evt) =>
      evt.preventDefault()  
      action = $(evt.currentTarget).data('action')
      if @btnHandlers[action]
        @btnHandlers[action]($(evt.currentTarget));
  # end setupToolbar
  
  setupMap: (el) ->
    @data_config = $(el).data()
    @data_config['displayProjection'] = @data_config['displayProjection'] || 'EPSG:4326'
    @config = Gina.Projections.get(@data_config['projection']);
    @config['projection'] = @data_config['projection']
    @config['displayProjection'] = @data_config['displayProjection']
    
    @map = new OpenLayers.Map(@data_config['openlayers'], @config)
    Gina.Layers.inject(@map, @data_config['layers']);
    @zoomToDefaultBounds()
  #end setupMap
  
  zoomToDefaultBounds: =>
    bounds = new OpenLayers.Bounds(-168.67373199615875, 56.046343829256664, -134.76560087596793, 70.81655788845131);
    bounds.transform('EPSG:4326', @data_config['projection']);
    @map.zoomToExtent(bounds , true);
  #end zoomToDefaultBounds  
#end CatalogMap

$(document).ready ->
  $('div[data-openlayers]').each -> 
    el = $(this).attr('id');
    new CatalogMap(this);