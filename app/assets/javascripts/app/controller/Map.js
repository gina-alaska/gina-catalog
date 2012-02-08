Ext.define('App.controller.Map', {
  extend: 'Ext.app.Controller',
  stores: ['Catalog', 'Filters'],

  refs: [{
    ref: 'mapPanel',
    selector: 'catalog_map'
  }, {
    ref: 'mapToolbar',
    selector: 'catalog_maptoolbar'
  }],

  init: function() {
    this.control({
      /* Map events */
      'catalog_map': {
        ready: this.onMapReady
      },
      'catalog_toolbar menuitem[action="aoi"]': {
        click: this.drawAOI
      },
      'catalog_list': {
        selectionchange: function(view, selections) {
          var record = selections[0];
          if( record ) {
            this.getMapPanel().loadRecordFeatures(record);
          } else {
            this.getMapPanel().loadFeatures();
          }
        }
      },
      'catalog_maptoolbar button[action="move"]': {
        click: function(button) {
          var tb = button.up('toolbar');
          var lat = tb.down('textfield[name="lat"]').getValue();
          var lon = tb.down('textfield[name="lon"]').getValue();
          var map = this.getMapPanel().getMap();
          
          var point = new OpenLayers.LonLat(lon, lat);
          point.transform(map.displayProjection, map.getProjectionObject());
          
          map.setCenter(point);
        }
      }
    });
  },
  
  drawAOI: function(){
    this.getMapPanel().control('aoi').activate();
  },
  
  onMapReady: function(map) {
    var catalog = this.getStore('Catalog');
    map.loadFeaturesFrom(catalog);
    
    map.getMap().events.register('moveend', this, this.onMoveEnd);
    map.getMap().events.register('mousemove', this, this.onMouseMove, { buffer: 300 });
  },
  onMouseMove: function(e) {
    var tb = this.getMapToolbar(),
        map = this.getMapPanel().getMap();
    var p = map.getLonLatFromPixel(map.events.getMousePosition(e));
    p.transform(map.getProjectionObject(), map.displayProjection);
    tb.updateMouse(p);    
  },
  onMoveEnd: function(e) {
    var tb = this.getMapToolbar();
    var p = e.object.getCenter();
    p.transform(e.object.getProjectionObject(), e.object.displayProjection);
    tb.updateCenter(p);    
  }
});