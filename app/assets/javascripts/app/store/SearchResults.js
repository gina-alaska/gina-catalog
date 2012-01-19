Ext.define('App.store.SearchResults', {
  extend: 'Ext.data.Store',
  
  storeId: 'SearchResults',
  model: 'App.model.SearchResult',
  proxy: {
    type: 'ajax',
    url: '/data.json',
    method: 'POST',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'results'
    }
  },
  
  pageSize: 3000,
  remoteSort: false,
  remoteFilter: true,
  autoLoad: false,
  listeners: {
//    exception: Ext.ux.StoreHandlers.failure
  },

  aoiFilter: function(geom, map) {
    var fn = Ext.bind(function(record, geom, map) {
      var features = map.featureCache.get(record.get('id'));
      if(Ext.isArray(features)) {
        return Ext.Array.some(features, function(f) {
          if(geom.intersects(f.geometry)) { return true; }
        }, this);
      } else {
        return false;
      }
    }, this, [geom, map], true);

    this.addFilterFn('aoi', 'AOI Search', fn);
  }
});
