Ext.define('App.controller.Map', {
  extend: 'Ext.app.Controller',
  stores: ['Catalog', 'Filters'],

  refs: [{
    ref: 'mapPanel',
    selector: 'catalog_map'
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
        
      }
    });
  },
  
  drawAOI: function(){
    this.getMapPanel().control('aoi').activate();
  },
  
  onMapReady: function(map) {
    var catalog = this.getStore('Catalog');
    map.loadFeaturesFrom(catalog);
  }
});