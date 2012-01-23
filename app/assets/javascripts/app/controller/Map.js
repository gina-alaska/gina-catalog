Ext.define('App.controller.Map', {
  extend: 'Ext.app.Controller',


  stores: ['Catalog', 'Filters'],

  init: function() {
    this.control({
      /* Map events */
      'catalog_map': {
        ready: this.onMapReady
      }
    });
  },
  
  onMapReady: function(map) {
    var catalog = this.getStore('Catalog');
    map.loadFeaturesFrom(catalog);
  }
});