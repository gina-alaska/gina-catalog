class Layers
  constructor: (@mapel, @map, @selector = 'layer') ->
    @config = @mapel.data()
  setup: () ->
    layers = {}
    layersForControl = {}
    #  = L.featureGroup()

    for el in @mapel.find('layer')
      klass = @determineLayerClass(el)

      layers[klass.zoomable] ||= L.featureGroup()
      layer = new klass(el, layers[klass.zoomable])
      layer.zoom(@)
      layersForControl[layer.config.name] = layer.getLayer()

    layers[true].addTo(@map) if layers[true]?
    layers[false].addTo(@map) if layers[false]?
    @zoomTo(layers[true], @config.maxZoom) if @config.fitAll

    L.control.layers(null, layersForControl).addTo(@map)
    L.control.coordinates(
      position: 'bottomleft'
      decimals: 3
      decimalSeperator: '.'
      labelTemplateLat: 'Lat: {y}'
      labelTemplateLng: 'Lon: {x}'
      enableUserInput: false
      useDMS: false
      useLatLngOrder: true
      markerType: L.marker
      markerProps: {}
    ).addTo @map

  zoomTo: (layer, maxZoom) ->
    @map.whenReady =>
      setTimeout(=>
        bounds = layer.getBounds()
        if bounds.isValid()
          @map.fitBounds(bounds, { padding: [30,30], maxZoom: maxZoom })
      , 1000)

  determineLayerClass: (el) ->
    switch $(el).data('type')
      when "GeoJSON"
        GeoJSONLayer
      when "WMS"
        WMSLayer
      when "TMS"
        TMSLayer
      else
        GeoJSONLayer

$(document).on 'ready page:load init_map', ->
  mapel = $('[data-behavior="map"]')

  if mapel.length > 0
    config = mapel.data()
    L.mapbox.accessToken = config.accessToken || 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
    @map = L.mapbox.map(mapel.data('target'), config.mapboxId, config);
    mapel.data('map', @map)

    layers = new Layers(mapel, @map)
    layers.setup();

$(document).on 'click', '[data-behavior="highlight-markers"]', (e) =>
  e.preventDefault()
  map = $('[data-behavior="map"]').data('map')
  el = $(e.target).data('target')

  map.once 'zoomend', =>
    # add delay because of marker cluster adding and removing dom elements
    setTimeout =>
      $(el).addClass('active')
    , 150

  $(el).parents('.leaflet-marker-pane').find('.active').removeClass('active')
  $(el).addClass('active')

  wkt = new Wkt.Wkt($(e.target).data('zoomto'))
  map.fitBounds(wkt.toObject().getBounds(), { padding: [10,10] })
