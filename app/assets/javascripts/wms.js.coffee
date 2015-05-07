class @WMSLayer
  constructor: (@el, @parent) ->
    @config = $(@el).data();

    @layer = L.tileLayer.wms(@config.url, {
      layers: @config.layers,
      format: 'image/png',
      transparent: true
    })
    @layer.addTo(@parent)

  zoom: (parent) ->
    # do nothing

  @zoomable: false
