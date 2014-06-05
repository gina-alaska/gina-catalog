# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class @MapLayers
  constructor: (@config) ->
    
  build: ->
    switch @config['type']
      when "WmsLayer" then @build_wms_layer()
      when "TileLayer" then @build_tile_layer()
      when "ArcLayer" then @build_arc_layer()
      else @boom("Unknown layer type #{@config['type']}")
        
  boom: (msg) ->
    console.log("Error creating map layer: #{msg}")
    
  build_arc_layer: ->
    console.log 'test'
    new OpenLayers.Layer.ArcGIS93Rest(@config['name'], @config['url'], { transparent: true, layers: @config['layers'], srs: 'EPSG:3857', format: ''  }, { isBaseLayer: false })  
    
  build_tile_layer: ->
    opts = {
      wrapDateLine: true,
      isBaseLayer: false,
      sphericalMercator: true,
      transitionEffect: 'resize'
    }
    new OpenLayers.Layer.XYZ(@config['name'], @config['url'].replace(/{/g, '${'), opts)
    
  build_wms_layer: ->
    new OpenLayers.Layer.WMS(@config['name'], @config['url'], { layers: @config['layers'], transparent: true }, { isBaseLayer: false })