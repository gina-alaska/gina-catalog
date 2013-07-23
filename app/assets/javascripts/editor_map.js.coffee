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
    
    @edit_features = new OpenLayers.Control.ModifyFeature(@vector)
    @map.addControl(@edit_features)
    
    @wktreader = new OpenLayers.Format.WKT()
    
    @addBtnHandler('clear', @clear)
    @addBtnHandler('reset', @addFeature)
    @addBtnHandler('draw', (evt, el) =>
      @drawFeature($(el).data('type'))
    )
  #end setupMap
  
  addFeature: (input = null) =>
    return false unless input?
    
    @clear()
    @input = input 
    wkt = @input.val()
    
    if wkt? and wkt != ''
      @feature = @wktreader.read(wkt)
      @feature.geometry.transform('EPSG:4326', @map.projection)
      @vector.addFeatures([@feature])
      @edit_features.selectFeature(@feature)
    else
      @feature = null
      
    @feature
      
  clear: =>
    @vector.removeAllFeatures()
    @feature = null
    
  drawFeature: (type) =>
    center = @map.getCenter()
    center_geom = new OpenLayers.Geometry.Point(center.lon, center.lat);
    
    switch type
      when 'polygon'
        width = 0.5 * @map.getExtent().getWidth()
        height = 0.5 * @map.getExtent().getHeight()
        
        radius = if width < height then width else height
        geom = OpenLayers.Geometry.Polygon.createRegularPolygon(center_geom, radius, 4)
      when 'point'
        geom = center_geom
        
    #if a feature is already in the map check its type
    if !@feature? or @feature.geometry.CLASS_NAME != geom.CLASS_NAME 
      #if the feature type is the different create the new geom and start drawing!
      @startDrawing(geom)
    
  startDrawing: (geom) =>
    @clear()
    @feature = new OpenLayers.Feature.Vector(geom)
    @vector.addFeatures([@feature])
    @edit_features.selectFeature(@feature)
    
  getWKT: =>
    f = @feature.geometry.clone()
    f.transform(@map.projection, 'EPSG:4326')
    f.toString()
#end CatalogMap