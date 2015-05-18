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

class @GeoJSONLayer
  @geojson_options: {
    'custom-marker': CustomMarker.build,
    'custom-popup': CustomPopup.build
  }

  constructor: (@el, @parent) ->
    @config = @config_from_element(@el)

    if @config.cluster
      @cluster = @cluster_layer()
      @cluster.addTo(@parent)
      @layer = @build_layer(@cluster)
    else
      @layer = @build_layer(@parent)

  register_geojson_options_builder: (name, klass) ->
    GeoJSONLayer.geojson_options[name] = klass

  fetch_geojson_options_builder: (name, options) ->
    GeoJSONLayer.geojson_options[name](options)

  valid_geojson_options_builder: (name) ->
    GeoJSONLayer.geojson_options[name]?

  next_page: (uri) ->
    url = new URI(uri)
    data = url.search(true)
    @url_defaults(uri, { page: parseInt(data.page) + 1 || 1 })

  url_defaults: (uri, defaults = nil) ->
    url = new URI(uri)

    data = url.search(true)
    params = $.extend(data, defaults) if defaults?

    url.search(params)
    url.toString()

  getLayer: () ->
    if @cluster?
      @cluster
    else
      @layer

  get_geojson_layer: (config = {}) ->
    featureLayer = L.mapbox.featureLayer(@url_defaults(config.url, { limit: 500 }))

    if config.paged?
      config.url = @next_page(config.url)

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


  build_layer: (parent) ->
    layer = @get_geojson_layer(@config)
    layer.on 'ready', =>
      layer.addTo(parent)
      if @config.paged? && layer.getLayers().length > 0
        @build_layer(parent)

    layer


  config_from_element: (el) ->
    config = $(el).data()
    if $(el).find('popup').length > 0
      config.popup = $(el).find('popup').html()

    config

  cluster_layer: (layer = null) ->
    new L.MarkerClusterGroup({
      maxClusterRadius: 25
    })

  zoom: (parent) ->
    parent.zoomTo(@layer, 10) if @config.fit

  @zoomable: true
