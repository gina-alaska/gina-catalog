class @LocationEditor
  constructor: (@map) ->
    @vector = new OpenLayers.Layer.Vector('Location')
    @map.addLayer(@vector)
    
    @edit_features = new OpenLayers.Control.ModifyFeature(@vector)
    @map.addControl(@edit_features)
    
    @wktreader = new OpenLayers.Format.WKT()
    
  addFeature: (input = null) =>
    @clear()

    @input = input if input?    
    wkt = @input.val()
    
    if wkt? and wkt != ''
      @feature = @wktreader.read(wkt)
      @feature.geometry.transform('EPSG:4326', @map.projection)
      @vector.addFeatures([@feature])
      @edit_features.selectFeature(@feature)
    else
      @feature = null
      
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
        console.log(radius)
        geom = OpenLayers.Geometry.Polygon.createRegularPolygon(center_geom, radius, 4)
      when 'point'
        geom = center_geom
        
    #if a feature is already in the map check its type
    if !@feature or @feature.geometry.CLASS_NAME != geom.CLASS_NAME 
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
    
#end LocationEditor