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
      if params.hideMarkerLabel or !feature.properties[params.markerLabelField]?
        label = ''
      else
        label = feature.properties[params.markerLabelField]

      L.marker(ll, {
        icon: L.divIcon({
          className: "",
          html: "
            <div class='marker_#{feature.properties['id']} #{params.iconClass}' style='background: #{params.color}'>
              #{label}
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
    if config.paged?
      url = new URI(config.url)
      data = url.search(true)
      data.page = parseInt(data.page) + 1 || 1
      data.limit = 500
      url.search(data)

      config.url = url.toString()
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

  @load: (el, parent) ->
    config = @config_from_element(el)

    if config.cluster
      cluster = @cluster_layer()
      cluster.addTo(parent)
      @build_layer(config, cluster)
    else
      @build_layer(config, parent)


  @build_layer: (config, parent) ->
    layer = @get_geojson_layer(config)
    layer.on 'ready', =>
      layer.addTo(parent)
      if config.paged? && layer.getLayers().length > 0
        @build_layer(config, parent)


  @config_from_element: (el) ->
    config = $(el).data()
    if $(el).find('popup').length > 0
      config.popup = $(el).find('popup').html()

    config

  @cluster_layer: (layer = null) ->
    new L.MarkerClusterGroup({
      maxClusterRadius: 25
    })

  @zoomTo: (map, layer, max = 10) ->
    map.whenReady =>
      bounds = layer.getBounds()
      if bounds.isValid()
        map.fitBounds(layer.getBounds(), { padding: [30,30], maxZoom: max })


$(document).on 'ready page:load', ->
  mapel = $('[data-behavior="map"]')

  if mapel.length > 0
    config = mapel.data()
    L.mapbox.accessToken = config.accessToken || 'pk.eyJ1IjoiZ2luYS1hbGFza2EiLCJhIjoiN0lJVnk5QSJ9.CsQYpUUXtdCpnUdwurAYcQ';
    @map = L.mapbox.map(mapel.data('target'), config.mapboxId, config);
    mapel.data('map', @map)

    if config.cluster
      @group = Layer.cluster_layer()
    else
      @group = L.featureGroup()

    @group.addTo(@map)

    for el in mapel.find('layer')
      layer = Layer.load(el, @group)
      if $(el).data('fit')
        layer.on 'ready', =>
          Layer.zoomTo(@map, layer, $(el).data('maxZoom'))

    setTimeout(=>
      Layer.zoomTo(@map, @group, config.maxZoom) if config.fitAll
    , 1000)


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
