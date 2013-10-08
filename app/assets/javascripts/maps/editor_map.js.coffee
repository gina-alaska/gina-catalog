class @EditorMap extends OpenlayersMap
  constructor: (@el) ->
    super(@el)
    
    @btnHandlers = {}
    @setupToolbar()
    @setupEditorMap()
    
  # end constructor
  
  addBtnHandler: (name, func) =>
    @btnHandlers[name] = func
  #end addBtnHandler  
  
  setupToolbar: =>
    @addBtnHandler 'zoomToMaxExtent', @zoomToDefaultBounds
      
    @btns = $(@el).parent().find('.btn[data-openlayers-action]')
    @btns.on 'click', (evt) =>
      evt.preventDefault()
      action = $(evt.currentTarget).data('openlayers-action')
      if @btnHandlers[action]
        @btnHandlers[action](evt, $(evt.currentTarget));
  # end setupToolbar
  
  setupEditorMap: ->
    @vector = new OpenLayers.Layer.Vector('Location')
    @map.addLayer(@vector)
    
    @controls = {
      point: new OpenLayers.Control.DrawFeature(@vector,
                  OpenLayers.Handler.Point, { featureAdded: @finishFeature }),
      line: new OpenLayers.Control.DrawFeature(@vector,
                  OpenLayers.Handler.Path, { featureAdded: @finishFeature }),
      polygon: new OpenLayers.Control.DrawFeature(@vector,
                  OpenLayers.Handler.Polygon, { featureAdded: @finishFeature }),
      modify: new OpenLayers.Control.ModifyFeature(@vector)
    }
    
    for name, control of @controls
      @map.addControl(control)
    
    # @edit_features = new OpenLayers.Control.ModifyFeature(@vector)
    # @map.addControl(@edit_features)
    # @edit_features.activate()
    
    @wktreader = new OpenLayers.Format.WKT()
    
    @addBtnHandler('clear', @clear)
    @addBtnHandler('reset', @resetFeature)
    @addBtnHandler('draw', (evt, el) =>
      @drawFeature($(el).data('type'))
    )
  #end setupMap
  
  finishFeature: =>
    for name, control of @controls
      control.deactivate()
    @controls.modify.activate()
        
  resetFeature: =>
    @addFeature(@original)    
  
  addFeature: (wkt) =>
    @original = wkt
    @clear()
    if wkt? and wkt != ''
      feature = @wktreader.read(wkt)
      feature.geometry.transform('EPSG:4326', @map.projection)
      @vector.addFeatures([feature])
      @controls.modify.selectFeature(feature)
      @controls.modify.activate()
      
    feature
      
  clear: =>
    @controls.modify.deactivate()
    @vector.removeAllFeatures()
    
  drawFeature: (type) =>
    @clear()
    
    switch type
      when 'polygon'
        @controls.polygon.activate()
        # width = 0.5 * @map.getExtent().getWidth()
        # height = 0.5 * @map.getExtent().getHeight()
        # 
        # radius = if width < height then width else height
        # geom = OpenLayers.Geometry.Polygon.createRegularPolygon(center_geom, radius, 4)
      when 'point'
        @controls.point.activate()
        # geom = center_geom
        
    #if a feature is already in the map check its type
    # if !@feature? or @feature.geometry.CLASS_NAME != geom.CLASS_NAME 
    #   #if the feature type is the different create the new geom and start drawing!
    #   @startDrawing(geom)
    
  startDrawing: (geom) =>
    # @clear()
    # @feature = new OpenLayers.Feature.Vector(geom)
    # @vector.addFeatures([@feature])
    # @edit_features.selectFeature(@feature)
    
  getWKT: =>
    f = @vector.features[0].geometry.clone()
    # f = @feature.geometry.clone()
    f.transform(@map.projection, 'EPSG:4326')
    f.toString()
#end CatalogMap