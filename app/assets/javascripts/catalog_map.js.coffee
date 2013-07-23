map_size = { hidden: false, large: false, fullscreen: false }
map_size_target = null

class @CatalogMap extends OpenlayersMap
  constructor: (@el) ->
    super(@el)
    
    @btnHandlers = {}
    @map_state = { target: '.search', size: History.getState().data.map_size || 'normal' }
    @setupCatalogMap()
    @setupToolbar()
    
    if map_size_target 
      for size, active of map_size when active is true
        @expandMap(map_size_target, size) 
            
    @loadMapState()
    @loadFeatures()
    
  # end constructor
  
  loadFeatures: =>
    unless @result_feature_layer?
      @result_feature_layer = new OpenLayers.Layer.Vector('Search Results', { styleMap: @styleMap, rendererOptions: {zIndexing: true} })
      @map.addLayer(@result_feature_layer)
    
    geoms = $('[data-wkt]');
    return unless geoms.length > 0 and $('#map').data('map') 
        
    @result_feature_layer.destroyFeatures()
    
    geoms.each (k, result) =>
      return unless $(result).data('wkt')
    
      features = @wktReader.read($(result).data('wkt'));
      if features.length > 0
        $(features).each (k,f) =>
          f.geometry.transform('EPSG:4326', @map.projection);
          f.attributes = { record_id: $(result).attr('id'), type: $(result).data('type') }
          
        @result_feature_layer.addFeatures(features)
        #save features back to dom object for later use to interact with the map
        $(result).data('features', features)
        
    @centerOnData(@result_feature_layer)
        
  centerOnData: (layer) =>
    if layer.features.length > 0
      @zoomToBounds(layer.getDataExtent())
  
  addBtnHandler: (name, func) =>
    @btnHandlers[name] = func
  #end addBtnHandler
  
  expandMap: (target, size) ->
    return false unless target?
    if size?
      @map_state ||= { target: target, size: 'normal' }
      
      @map_state.target = target
      @map_state.previous_size = @map_state.size
      
      if $(target).hasClass(size)
        @map_state.size = 'normal'
      else
        @map_state.size = size
              
      @loadMapState()

  loadMapState: (size) =>
    if size? and size != @map_state.size
      @expandMap(@map_state.target, size)
    else
      if $(@map_state.target).hasClass(@map_state.previous_size)
        $(@map_state.target).removeClass(@map_state.previous_size)
      
      $(@map_state.target).addClass(@map_state.size)
      
      for btn in @btns when $(btn).data('openlayers-action') is 'expand'
        $(btn).removeClass('active') if $(btn).data('size') != @map_state.size
        $(btn).addClass('active') if $(btn).data('size') == @map_state.size
      
      @resize()      
      
  setupToolbar: =>
    @addBtnHandler 'drawAOI', @drawAOI
    @addBtnHandler 'zoomToMaxExtent', @zoomToDefaultBounds
    @addBtnHandler 'expand', (evt, btn) =>
      @expandMap(btn.data('target'), btn.data('size'), btn)
      
    @btns = $(@el).parent().find('.btn[data-openlayers-action]')
    @btns.on 'click', (evt) =>
      evt.preventDefault()
      action = $(evt.currentTarget).data('openlayers-action')
      if @btnHandlers[action]
        @btnHandlers[action](evt, $(evt.currentTarget));
  # end setupToolbar
  
  setupCatalogMap: () ->
    unless @aoiLayer?
      aoiStyle = new OpenLayers.StyleMap({
        default: new OpenLayers.Style({
          fillColor: '#00ff00', 
          fillOpacity: 0.2,
          strokeColor: '#00ff00',
          strokeOpacity: 0.8,
          strokeWidth: 1
        })
      })
      @aoiLayer = new OpenLayers.Layer.Vector("AOI Search", {           
        displayInLayerSwitcher: false,
        styleMap: aoiStyle, 
      })
    
      @map.addLayer(@aoiLayer)
      
    if @data_config['aoiInputField']
      @addAOI($(@data_config['aoiInputField']).val())    
  #end setupMap
    
  addAOI:(wkt) =>
    wktReader = new OpenLayers.Format.WKT()
    feature = wktReader.read(wkt);

    if feature
      @aoiLayer.removeAllFeatures()
      feature.geometry.transform('EPSG:4326', @map.projection);
      @aoiLayer.addFeatures([feature])
    
    
  drawAOI:(evt, btn) =>
    @setupAOIControl(evt, btn)
    @aoiLayer.removeAllFeatures()
    $.event.trigger({
      type: 'openlayers:aoidraw',
      map: @map,
      mapInstance: this
    })
    @aoiDrawControl.activate()    
  
  setupAOIControl: (evt, btn) =>      
    unless @aoiDrawControl
      @aoiDrawControl = new OpenLayers.Control.DrawFeature(@aoiLayer,
        OpenLayers.Handler.RegularPolygon, {
          autoActivate: false,
          documentDrag: true,
          featureAdded: (feature) =>
            @aoiDrawControl.deactivate()
            
            feature.geometry.transform(@config['projection'], @config['displayProjection'])
            this.addAOI(feature.geometry.toString())
            
            $.event.trigger({
              type: 'openlayers:aoidrawn',
              wkt: feature.geometry.toString(),
              map: @map,
              mapInstance: this
            })
          handlerOptions: {
            documentDrag: true,
            sides: 4,
            irregular: true
          }
        }
      )
      @aoiDrawControl.events.register 'activate', btn, ->
        $(this).addClass('active')
      @aoiDrawControl.events.register 'deactivate', btn, ->
        $(this).removeClass('active')
      
      @map.addControl(@aoiDrawControl)
  #end setupAOIControl
#end CatalogMap
