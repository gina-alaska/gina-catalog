map_size = { hidden: false, large: false, fullscreen: false }
map_size_target = null

class CatalogMap
  constructor: (@el) ->
    @btnHandlers = {}
    @map_state = { target: '.search', size: History.getState().data.map_size || 'normal' }
    @setupMap(@el)
    @setupToolbar()
    
    if map_size_target 
      for size, active of map_size when active is true
        @expandMap(map_size_target, size) 
    
    
    $(@el).data('map', this)
    @loadMapState()
    
  # end constructor
  
  addBtnHandler: (name, func) =>
    @btnHandlers[name] = func
  #end addBtnHandler
  
  expandMap: (target, size) ->
    return false unless target?
    if size?
      @map_state ||= { target: target, size: 'normal' }
      
      @map_state.target = target
      @map_state.previous_size = @map_state.size
      
      if $(target).hasClass(size)
        @map_state.size = 'normal'
      else
        @map_state.size = size
              
      @loadMapState()

  loadMapState: (size) =>
    if size? and size != @map_state.size
      console.log 'resize'
      @expandMap(@map_state.target, size)
    else
      if $(@map_state.target).hasClass(@map_state.previous_size)
        $(@map_state.target).removeClass(@map_state.previous_size)
      
      $(@map_state.target).addClass(@map_state.size)
      
      for btn in @btns when $(btn).data('openlayers-action') is 'expand'
        $(btn).removeClass('active') if $(btn).data('size') != @map_state.size
        $(btn).addClass('active') if $(btn).data('size') == @map_state.size
      
      @resize()      
      
  setupToolbar: =>
    @addBtnHandler 'zoomToMaxExtent', @zoomToDefaultBounds
    @addBtnHandler 'expand', (evt, btn) =>
      @expandMap(btn.data('target'), btn.data('size'), btn)
      
    @btns = $(@el).find('.btn[data-openlayers-action]')
    @btns.on 'click', (evt) =>
      evt.preventDefault()
      action = $(evt.currentTarget).data('openlayers-action')
      if @btnHandlers[action]
        @btnHandlers[action](evt, $(evt.currentTarget));
  # end setupToolbar
  
  setupMap: (el) ->
    @data_config = $(el).data()
    @data_config['displayProjection'] = @data_config['displayProjection'] || 'EPSG:4326'
    @config = Gina.Projections.get(@data_config['projection']);
    @config['projection'] = @data_config['projection']
    @config['displayProjection'] = @data_config['displayProjection'] || 'EPSG:4326'
    @config['zoomMethod'] = OpenLayers.Easing.Quad.easeOut
    @config['zoomDuratoin'] = 5
    
    # @default_bounds = new OpenLayers.Bounds(-168.67373199615875, 56.046343829256664, -134.76560087596793, 70.81655788845131);
    @default_bounds = new OpenLayers.Bounds(162.0498, 45, -106.7196, 76);
    @default_bounds.transform('EPSG:4326', @data_config['projection']);
    
    @map = new OpenLayers.Map(@data_config['openlayers'], @config)
    @map.addControls([
      new OpenLayers.Control.LayerSwitcher(),
      new OpenLayers.Control.MousePosition({ displayProjection: @map.displayProjection, numDigits: 3, prefix: 'Mouse: ' })
    ])

    if @data_config['google']
      @add_google_layers()

    Gina.Layers.inject(@map, @data_config['layers']);
    @zoomToDefaultBounds()
    
    @ready()
  #end setupMap
  
  setDefaultBounds: (bounds) =>
    @default_bounds = bounds
  
  zoomToDefaultBounds: =>
    @map.zoomToExtent(@default_bounds, true);
    
  #end zoomToDefaultBounds  

  resize: =>
    @map.updateSize()
    $.event.trigger({
      type: 'openlayers:resize',
      map: @map
    })

  add_google_layers: =>
    layers = [
      new OpenLayers.Layer.Google(
          "Google Physical",
          {type: google.maps.MapTypeId.TERRAIN}
      ),
      new OpenLayers.Layer.Google(
          "Google Streets",
          {numZoomLevels: 20}
      ),
      new OpenLayers.Layer.Google(
          "Google Hybrid",
          {type: google.maps.MapTypeId.HYBRID, numZoomLevels: 20}
      ),
      new OpenLayers.Layer.Google(
          "Google Satellite",
          {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22}
      )
    ]
    @map.addLayers layers

  ready: =>
    $('#map_canvas').on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", (evt) =>
      @resize() if $(evt.target).attr('id') == 'map_canvas'
    
    setTimeout(=>
      $("##{@data_config['openlayers']}").addClass('ready')      
      @map.updateSize()
      
      $.event.trigger({
        type: 'openlayers:ready',
        map: @map,
        mapInstance: this
      })
    , 1000)
#end CatalogMap

map_init = ->
  $('div[data-openlayers]').each -> 
    el = $(this).attr('id');
    map = new CatalogMap(this);


$(document).ready ->
  map_init();
  # $(document).on 'page:load', map_init
