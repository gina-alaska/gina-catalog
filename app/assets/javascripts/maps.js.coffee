class Layers
  constructor: (@mapel, @map, @selector = 'layer') ->
    @config = @mapel.data()
  setup: () ->
    layers = {}
    layersForControl = {
    }
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

    layersForControl['DNR Orthos'] = L.tileLayer('http://gis2.dnr.alaska.gov/terrapixel/ips/tilesets/SPOT5_SDMI_ORTHO_RGB/SPOT5_SDMI_ORTHO_RGB/default/smerc/{z}/{y}/{x}.png?INSTANCE=ortho')
    layersForControl['GINA Topos'] = L.tileLayer('http://tiles.gina.alaska.edu/tilesrv/drg/tile/{x}/{y}/{z}.png?GOGC=220EAC1F05E4')

    L.control.layers(null, layersForControl, { position: 'topleft' }).addTo(@map)

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

$(document).on 'ready turbolinks:load init_map', ->
  mapel = $('[data-behavior="map"]')

  if mapel.length > 0
    config = mapel.data()
    L.mapbox.accessToken = config.accessToken || 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
    @map = L.mapbox.map(mapel.data('target'), config.mapboxId, config);
    @map.setView([64.245, -152.051], 3);
    mapel.data('map', @map)

    layers = new Layers(mapel, @map)
    layers.setup();

$(document).on 'click', '[data-behavior="highlight-markers"]', (e) ->
  e.preventDefault()
  map = $('[data-behavior="map"]').data('map')
  el = $(this).data('target')

  $(el).parents('.leaflet-marker-pane').find('.active').removeClass('active')
  $(el).addClass('active')

  wkt = new Wkt.Wkt($(this).data('zoomto'))
  geom = wkt.toObject()

  if wkt.type == 'point'
    map.setView(geom.getLatLng(), 10)
  else
    map.fitBounds(geom.getBounds(), padding: [10, 10])

  $(el).addClass('active')
