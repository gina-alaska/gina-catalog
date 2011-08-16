Ext.define('App.store.Locations', {
  extend: 'Ext.data.Store',

  storeId: 'Locations',
  model: 'App.model.Location',
  proxy: { type: 'ajax', reader: { type: 'json' } },
  autoLoad: false,
  listeners: {
//    exception: Ext.ux.StoreHandlers.failure
  }
});