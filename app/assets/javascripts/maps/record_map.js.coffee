map_size = { hidden: false, large: false, fullscreen: false }
map_size_target = null

class @RecordMap extends OpenlayersMap
  constructor: (@el, size='normal') ->
    super(@el)
    
    @btnHandlers = {}
    @preview_layers_list = {}
    
    @map_state = { target: '.search', size: History.getState().data.map_size || 'normal' }
    @setupRecordMap()
    @initListeners()
    @setupHandlers()
    if map_size_target 
      for size, active of map_size when active is true
        @expandMap(map_size_target, size) 
            
    # @loadMapState()
    @loadFeatures()
    

    if size? and size != 'normal'
      $("[data-openlayers-action='expand'][data-size='#{size}']").click()
  # end constructor
  
  initListeners: =>
  
  loadFeatures: =>        
    @result_feature_layer.destroyFeatures()
    
    geoms = $('[data-wkt]');
    return unless geoms.length > 0 and @map?
    
    geoms.each (k, result) =>
      return unless wkt = $(result).data('wkt')
    
      features = @wktReader.read(wkt);
      if features.length > 0
        $(features).each (k,f) =>
          f.geometry.transform('EPSG:4326', @map.projection);
          f.attributes = { record_id: $(result).attr('id'), type: $(result).data('type') }
          
        @result_feature_layer.addFeatures(features)
        #save features back to dom object for later use to interact with the map
        $(result).data('features', features)
        
    @centerOnData(@result_feature_layer)
    
  centerOnData: (layer) =>
    if layer.features.length > 0
      @zoomToBounds(layer.getDataExtent())
  
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
      @expandMap(@map_state.target, size)
    else
      if $(@map_state.target).hasClass(@map_state.previous_size)
        $(@map_state.target).removeClass(@map_state.previous_size)
      
      $(@map_state.target).addClass(@map_state.size)
      
      for btn in @btns when $(btn).data('openlayers-action') is 'expand'
        $(btn).removeClass('active') if $(btn).data('size') != @map_state.size
        $(btn).addClass('active') if $(btn).data('size') == @map_state.size
      
      @resize()      
      
  setupHandlers: =>
    @addBtnHandler 'preview', @preview_layer
    @addBtnHandler 'zoomToMaxExtent', @zoomToDefaultBounds
    @addBtnHandler 'expand', (evt, btn) =>
      @expandMap(btn.data('target'), btn.data('size'), btn)
      
    @btns = $('[data-openlayers-action]')
    $(document).on 'click', '[data-openlayers-action]', (evt) =>
      evt.preventDefault()
      action = $(evt.currentTarget).data('openlayers-action')
      if @btnHandlers[action]
        @btnHandlers[action](evt, $(evt.currentTarget));
  # end setupToolbar
  
  setupRecordMap: () -> 
    lookup = {
      'Asset': { fillColor: '#3a87ad', strokeColor: '#3a87ad' },
      'Project': { fillColor: '#c09853', strokeColor: '#c09853' }
    }
    @styleMap = new OpenLayers.StyleMap({
      default: new OpenLayers.Style({
        graphicZIndex: 1,
        pointRadius: 6,
        fillColor: '#70faff', 
        fillOpacity: 0,
        strokeColor: '#70faff',
        strokeOpacity: 1,
        strokeWidth: 4
      }),
      select: new OpenLayers.Style({
        fillColor: '#f00',
        strokeColor: '#f00',
        strokeWidth: 2,
        graphicZIndex: 2
      })
    })
    @styleMap.addUniqueValueRules("default", "type", lookup)
    
    @result_feature_layer = new OpenLayers.Layer.Vector('Locations', { styleMap: @styleMap, rendererOptions: {zIndexing: true} })
    @map.addLayer(@result_feature_layer)
    @map.events.register 'addlayer', @, @moveFeaturesToTop
    
  #end setupMap
  
  moveFeaturesToTop: =>
    @map.setLayerIndex(@result_feature_layer, @map.getNumLayers());
  
  toggleCheck: (btn, checkbox, status) ->
    if status
      $(checkbox).addClass('icon-check').removeClass('icon-check-empty')
      $(btn).addClass('btn-success')
      
    else
      $(checkbox).removeClass('icon-check').addClass('icon-check-empty')
      $(btn).removeClass('btn-success') unless $(btn).parent().find('.icon-check').size() > 0
    
  
  preview_layer:(evt, link) =>
    return false if link.hasClass('disabled')
    
    href = link.attr('href')
    
    checkbox= $(link).find('i.check')
    if $(link).hasClass('btn')
      btn = link
    else
      btn = $(link).parents('ul').siblings('.btn')
    
    if @preview_layers_list[href]?
      @preview_layers_list[href].destroy()
      delete(@preview_layers_list[href])
      # @preview_layers_list[href].setVisibility(!@preview_layers_list[href].getVisibility())
      @toggleCheck(btn, checkbox, false)
      
    else
      $.ajax(href).success (response) =>
        maplayer = new MapLayers(response)
        @preview_layers_list[href] = maplayer.build()
        @map.addLayer(@preview_layers_list[href])
        @toggleCheck(btn, checkbox, true)
    
  #end setupAOIControl
#end CatalogMap
