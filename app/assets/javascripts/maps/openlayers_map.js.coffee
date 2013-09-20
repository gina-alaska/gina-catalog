class @OpenlayersMap
  constructor: (@el) ->
    @setupMap(@el)
    @wktReader = new OpenLayers.Format.WKT()
    $(@el).data('map', this)
    
  # end constructor  
  setupMap: (el) ->
    @data_config = $(el).data()
    @data_config['displayProjection'] = @data_config['displayProjection'] || 'EPSG:4326'
    @config = Gina.Projections.get(@data_config['projection']);
    @config['projection'] = @data_config['projection']
    @config['displayProjection'] = @data_config['displayProjection'] || 'EPSG:4326'
    
    @config['zoomMethod'] = OpenLayers.Easing.Quad.easeOut
    @config['zoomDuration'] = 5
    
    @default_bounds = new OpenLayers.Bounds(162.0498, 45, -106.7196, 76);
    @default_bounds.transform('EPSG:4326', @data_config['projection']);
    
    # strip out the # for openlayers
    @map = new OpenLayers.Map(el.replace('#', ''), @config)
    @map.addControls([
      new OpenLayers.Control.LayerSwitcher(),
      new OpenLayers.Control.MousePosition({ displayProjection: @map.displayProjection, numDigits: 3, prefix: 'Mouse: ' })
    ])

    if @data_config['google'] and @config['projection'] == "EPSG:3857"
      @add_google_layers()

    Gina.Layers.inject(@map, @data_config['layers']);
        
    @zoomToDefaultBounds()
    
    @ready()
  #end setupMap
  
  setDefaultBounds: (bounds) =>
    @default_bounds = bounds
  
  zoomToDefaultBounds: =>
    @map.zoomToExtent(@default_bounds, true);
  #end zoomToDefaultBounds  

  zoomToBounds: (bounds, maxZoom = 6) =>
    zoom = @map.getZoomForExtent(bounds)
    center = bounds.getCenterLonLat()
    
    if zoom > maxZoom
      zoom = maxZoom

    @map.zoomTo(zoom)
    @map.setCenter(center)

  resize: =>
    @map.updateSize()
    $.event.trigger({
      type: 'openlayers:resize',
      map: @map
    })

  add_google_layers: =>
    layers = [
      new OpenLayers.Layer.Google(
          "Google Physical",
          {type: google.maps.MapTypeId.TERRAIN}
      ),
      new OpenLayers.Layer.Google(
          "Google Streets",
          {numZoomLevels: 20}
      ),
      new OpenLayers.Layer.Google(
          "Google Hybrid",
          {type: google.maps.MapTypeId.HYBRID, numZoomLevels: 20}
      ),
      new OpenLayers.Layer.Google(
          "Google Satellite",
          {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22}
      )
    ]
    @map.addLayers layers

  ready: =>
    $('#map_canvas').on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", (evt) =>
      @resize() if $(evt.target).attr('id') == 'map_canvas'
    
    setTimeout(=>
      $("##{@data_config['openlayers']}").addClass('ready')      
      @map.updateSize()
      
      $.event.trigger({
        type: 'openlayers:ready',
        map: @map,
        mapInstance: this
      })
    , 1000)
#end OpenlayersMap