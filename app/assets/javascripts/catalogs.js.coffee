class Catalog
  constructor: (@map) ->
    @initListeners()
    @setupLayers()    
    @wktReader = new OpenLayers.Format.WKT()
    @loadFeatures()
    
  initListeners: =>
    $(document).on('click', "[data-openlayers-action='select-features']", @selectResultFeatures)
    # $(document).on('page:fetch').unbind('click', @selectResultFeatures)

  selectResultFeatures: (evt) =>
    evt.preventDefault()
    target = $(evt.currentTarget).data('target')
    features = $(target).data("features")
    @selectControl.unselectAll()
    
    bounds = features[0].geometry.getBounds().clone()

    @selectControl.multiple = true
    @selectControl.multipleSelect()
    
    # use @skipHighlight to only scroll to the result the first time it's clicked on
    @skipHighlight = false
    
    for feature in features
      bounds.extend(feature.geometry.getBounds())
      @selectControl.select(feature) 
      @skipHighlight = true
      
    @skipHighlight = false
    @selectControl.multiple = false
    @selectControl.multipleSelect()
    # @selectControl.multipleSelect(false)
    @zoomToBounds(bounds)

  setupLayers: =>
    lookup = {
      'Asset': { fillColor: '#3a87ad', strokeColor: '#3a87ad' },
      'Project': { fillColor: '#c09853', strokeColor: '#c09853' }
    }
    @styleMap = new OpenLayers.StyleMap({
      default: new OpenLayers.Style({
        graphicZIndex: 1,
        pointRadius: 6,
        fillColor: '#3a87ad', 
        fillOpacity: 0.8,
        strokeColor: '#3a87ad',
        strokeOpacity: 1,
        strokeWidth: 1
      }),
      select: new OpenLayers.Style({
        fillColor: '#f00',
        strokeColor: '#f00',
        strokeWidth: 2,
        graphicZIndex: 2
      })
    })
    @styleMap.addUniqueValueRules("default", "type", lookup)
    
    @search_layer = new OpenLayers.Layer.Vector('Search Results', { styleMap: @styleMap, rendererOptions: {zIndexing: true} })
    
    @map.addLayer(@search_layer)
    
    @selectControl = new OpenLayers.Control.SelectFeature(@search_layer, {
      autoActivate: true,
      onUnselect: () =>
        if @higlightEl
          @higlightEl.removeClass('highlight')
        
      onSelect: (feature) =>
        unless @skipHighlight
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
    
    @map.addControl(@selectControl)
    # $(document).on 'openlayers:resize', (evt) =>
    #   @centerOnData()
    
  loadFeatures: =>
    console.log 'foo'
    @search_layer.destroyFeatures()

    geoms = $('[data-wkt]');
    return unless geoms.length > 0 and $('#map').data('map') 
    
    # @map = $('#map').data('map').map
    return unless @map
    
    geoms.each (k, result) =>
      return unless wkts = $(result).data('wkt')
    
      features = @wktReader.read(wkts);
      if features.length > 0
        $(features).each (k,f) =>
          f.geometry.transform('EPSG:4326', @map.projection);
          f.attributes = { record_id: $(result).attr('id'), type: $(result).data('type') }
          
        @search_layer.addFeatures(features)
        #save features back to dom object for later use to interact with the map
        $(result).data('features', features)
        
    @centerOnData()
        
  centerOnData: =>
    if @search_layer.features.length > 0
      @zoomToBounds(@search_layer.getDataExtent())
  
  zoomToBounds: (bounds, maxZoom = 6) =>
    zoom = @map.getZoomForExtent(bounds)
    center = bounds.getCenterLonLat()
    
    if zoom > maxZoom
      zoom = maxZoom

    @map.zoomTo(zoom)
    @map.setCenter(center)    
#end class Catalog
# 
# $(document).on 'openlayers:ready', (evt) -> 
#   $(document).data('catalog_map', new Catalog(evt.map));
