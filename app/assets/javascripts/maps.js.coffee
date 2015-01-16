class BaseOptionsBuilder
  @build: (params = {}, opts = {}) ->
    opts.style = L.mapbox.simplestyle.style
    opts

class CustomPopup extends BaseOptionsBuilder
  @build: (params = {}, opts = {}) ->
    opts = super(params, opts)

    if params.popup?
      opts.onEachFeature = (feature, layer) ->
        layer.bindPopup(L.mapbox.template(params.popup, feature.properties))

    opts

class CustomMarker extends CustomPopup
  @build: (params = {}, opts = {})->
    opts = super(params, opts)

    params.markerLabelField ||= 'title'
    params.iconSize ||= [30,30]
    params.iconClass ||= 'circle-marker'

    opts.pointToLayer = (feature, ll) ->
      params.color = feature.properties['marker-color'] || '#00f'
      L.marker(ll, {
        icon: L.divIcon({
          className: "",
          html: "
            <div class='marker_#{feature.properties['id']} #{params.iconClass}' style='background: #{params.color}'>
              #{feature.properties[params.markerLabelField]}
            </div>",
          iconSize: params.iconSize
        })
      })

    opts

class Layer
  @geojson_options: {
    'custom-marker': CustomMarker.build,
    'custom-popup': CustomPopup.build
  }

  @register_geojson_options_builder: (name, klass) ->
    Layer.geojson_options[name] = klass

  @fetch_geojson_options_builder: (name, options) ->
    Layer.geojson_options[name](options)

  @valid_geojson_options_builder: (name) ->
    Layer.geojson_options[name]?

  @get_geojson_layer: (config = {}) ->
    featureLayer = L.mapbox.featureLayer(config.url)

    if @valid_geojson_options_builder(config.geojsonOptions)
      geojson = L.geoJson(
        null,
        @fetch_geojson_options_builder(config.geojsonOptions, config)
      )
    else
      geojson = L.geoJson(
        null,
        @fetch_geojson_options_builder('custom-popup', config)
      )

    featureLayer.on 'ready', ->
      geojson.addData(this.getGeoJSON())
      geojson.fire('ready')

    geojson

  @from_element: (el, map) ->
    config = $(el).data()
    if $(el).find('popup').length > 0
      config.popup = $(el).find('popup').html()

    if config.cluster
      layer = new L.MarkerClusterGroup({
        maxClusterRadius: 25
      })
      _layer = @get_geojson_layer(config)
      _layer.on 'ready', =>
        # need to wait until ready so we know the data is available
        layer.addLayer(_layer)
        if config.fit
          @zoomTo(map, layer, config.maxAutoZoom)

    else
      layer = @get_geojson_layer(config)
      if config.fit
        layer.on 'ready', =>
          @zoomTo(map, layer, config.maxAutoZoom)

    layer

  @zoomTo: (map, layer, max = 10) ->
    map.whenReady =>
      map.fitBounds(layer.getBounds(), { padding: [30,30], maxZoom: max })

$(document).on 'ready page:load', ->
  mapel = $('[data-behavior="map"]')
  config = mapel.data()

  if mapel.length > 0
    L.mapbox.accessToken = config.accessToken || 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
    @map = L.mapbox.map(mapel.data('target'), config.mapboxId, config);
    mapel.data('map', @map)
    @group = L.featureGroup().addTo(@map)

    for layer in mapel.find('layer')
      l = Layer.from_element(layer, @map)
      @group.addLayer(l)
      if config.fitAll
        l.on 'ready', =>
          @map.whenReady =>
            @map.fitBounds(@group.getBounds(), { padding: [10,10] })

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

  wkt = new Wkt.Wkt($(e.target).data('zoomto'))
  map.fitBounds(wkt.toObject().getBounds(), { padding: [10,10] })
