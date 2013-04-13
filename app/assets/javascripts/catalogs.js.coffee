class Catalog
  constructor: ->
    
  addLayer: =>
    @layer = new OpenLayers.Layer.Vector('Search Results')
    
    @map.addLayer(@layer)
    
    select = new OpenLayers.Control.SelectFeature(@layer, {
      autoActivate: true,
      onSelect: (feature) =>
        el = $('#' + feature.attributes.record_id)
        parent = $('body')

        cur_scroll = parent.scrollTop()
        parent.animate({
          scrollTop: el.offset().top
        })
        el.effect("highlight", {}, 1500)
    })
    
    @map.addControl(select)
    
  loadFeatures: =>
    geoms = $('[data-wkt]');
    return unless geoms.length > 0 and $('#map').data('map') 
    
    @map = $('#map').data('map').map
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
      
    @map.zoomToExtent(@layer.getDataExtent())
          
  setup: ->
#end class Catalog

$(document).on 'ready', ->
  catalog = new Catalog()
  catalog.loadFeatures()
  $(document).on 'page:load', catalog.loadFeatures