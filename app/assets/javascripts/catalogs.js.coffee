class Catalog
  constructor: (@map) ->
    @loadFeatures()

  addLayer: =>
    @layer = new OpenLayers.Layer.Vector('Search Results')
    
    @map.addLayer(@layer)
    
    select = new OpenLayers.Control.SelectFeature(@layer, {
      autoActivate: true,
      onUnselect: () =>
        if @higlightEl
          @higlightEl.removeClass('highlight')
        
      onSelect: (feature) =>
        el = $('#' + feature.attributes.record_id).parent('td')
        parent = $('body,html')

        padding = $('#map').height()
         
        # .data('scroll-offset')
        parent.animate({
          scrollTop: el.offset().top - padding
        })
        
        #save this for later reset
        bgcolor = el.css('backgroundColor')
        
        el.addClass('highlight')
        @higlightEl = el
    })
    
    @map.addControl(select)
    # $(document).on 'openlayers:resize', (evt) =>
    #   @centerOnData()
    
  loadFeatures: =>
    geoms = $('[data-wkt]');
    return unless geoms.length > 0 and $('#map').data('map') 
    
    # @map = $('#map').data('map').map
    return unless @map
    
    @addLayer()    
    wktReader = new OpenLayers.Format.WKT()
    
    geoms.each (k, result) =>
      return unless $(result).data('wkt')
    
      features = wktReader.read($(result).data('wkt'));
      if features.length > 0
        $(features).each (k,f) =>
          f.geometry.transform('EPSG:4326', @map.projection);
          f.attributes = { record_id: $(result).attr('id'), type: $(result).data('type') }
          
        @layer.addFeatures(features)
        
    @centerOnData()
        
  centerOnData: =>
    if @layer.features.length > 0
      dextent = @layer.getDataExtent();
      zoom = @map.getZoomForExtent(dextent)
      center = dextent.getCenterLonLat()
      
      if zoom > 5
        zoom = 5

      @map.zoomTo(zoom)
      @map.setCenter(center)
      
      # @map.setDefaultBounds(@map.getExtent())
    
    
  setup: ->
#end class Catalog

$(document).on 'openlayers:ready', (evt) -> 
  new Catalog(evt.map)
