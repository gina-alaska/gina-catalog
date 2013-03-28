class CatalogMap
  contructor: (el) ->
    setupMap(el)
    
  setupMap: (el) ->
    @config = $(el).data()
    @map = new OpenLayers.Map(el, {
      projection: @config['projection']
    })
    Gina.Layers.inject(@map, @config['layers']);
    var bounds = new OpenLayers.Bounds(-19959236.823047, 6398696.5109183, -14206280.326993, 12269060.282403);
    @map.zoomToExtent(bounds, true);
    
$('div[data-openlayers]').each -> 
  el = $(this).attr('id');
  CatalogMap.new(el);