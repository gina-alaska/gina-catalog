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
      evt.preventDefault();
      @drawFeature($(el).data('type'))
    )
  #end setupMap
  
  finishFeature: =>
    @deactivateAll()
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

  isActive: (type) =>
    $("[data-openlayers-action=\"draw\"][data-type=\"#{type}\"]").hasClass('active')
    
  activateControl: (type) =>
    @deactivateAll()
    @controls[type].activate();
    $("[data-openlayers-action=\"draw\"][data-type=\"#{type}\"]").addClass('active')
    
    
  deactivateAll: =>
    for name, control of @controls
      control.deactivate()
      $("[data-openlayers-action=\"draw\"][data-type=\"#{name}\"]").removeClass('active')
  
  clear: =>
    @deactivateAll()
    @vector.removeAllFeatures()
    
  drawFeature: (type) =>
    if @isActive(type)
      @controls[type].finishSketch()
      @deactivateAll()
    else
      @clear()
      @activateControl(type)        

    
  getWKT: =>
    f = @vector.features[0].geometry.clone()
    # f = @feature.geometry.clone()
    f.transform(@map.projection, 'EPSG:4326')
    f.toString()
#end CatalogMap