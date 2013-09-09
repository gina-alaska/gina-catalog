# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class @MapLayers
  constructor: (@config) ->
    
  build: ->
    switch @config['type']
      when "WmsLayer" then @build_wms_layer()
      else @boom("Unknown layer type")
        
  boom: (msg) ->
    console.log("Error creating map layer: #{msg}")
    
  build_wms_layer: ->
    new OpenLayers.Layer.WMS(@config['name'], @config['url'], { layers: @config['layers'], transparent: true }, { isBaseLayer: false })