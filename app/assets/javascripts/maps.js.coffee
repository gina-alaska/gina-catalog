map_size = { large: false, fullscreen: false }
map_size_target = null

class CatalogMap
  constructor: (@el) ->
    @btnHandlers = {}
    
    @setupMap(@el)
    @setupToolbar()
    
    if map_size_target 
      for size, active of map_size when active is true
        @expandMap(map_size_target, size) 
    
    
    $(@el).data('map', this)
  # end constructor
  
  addBtnHandler: (name, func) =>
    @btnHandlers[name] = func
  #end addBtnHandler
  
  expandMap: (target, size, btn) ->
    return false unless target?
    
    if size?
      map_size_target = target
      if $(target).hasClass(size)
        $(target).removeClass(size)
        map_size[size] = false
        for btn in @btns when $(btn).data('openlayers-action') is 'expand'
          $(btn).removeClass('active') if $(btn).data('size') == size
      else
        $(target).addClass(size)
        map_size[size] = true
        for btn in @btns when $(btn).data('openlayers-action') is 'expand'
          $(btn).addClass('active') if $(btn).data('size') == size
        # for btn in $("[data-action='expand']") when $(btn).data('size') is size 
        #   $(btn).addClass('active') unless $(btn).hasClass('active')
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
    
    @default_bounds = new OpenLayers.Bounds(-168.67373199615875, 56.046343829256664, -134.76560087596793, 70.81655788845131);
    @default_bounds.transform('EPSG:4326', @data_config['projection']);
    
    @map = new OpenLayers.Map(@data_config['openlayers'], @config)
    @map.addControls([
      new OpenLayers.Control.LayerSwitcher(),
      new OpenLayers.Control.MousePosition({ displayProjection: @map.displayProjection, numDigits: 3, prefix: 'Mouse: ' })
    ])
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
