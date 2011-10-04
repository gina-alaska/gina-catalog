Ext.define('App.store.Filters', {
  extend: 'Ext.data.Store',

  storeId: 'Filters',
  model: 'App.model.Filter',
  autoLoad: false,
  listeners: {
//    exception: Ext.ux.StoreHandlers.failure
  }
});