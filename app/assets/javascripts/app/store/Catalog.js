Ext.define('App.store.Catalog', {
  extend: 'Ext.data.Store',
  
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
  remoteSort: true,
  remoteFilter: true,
  autoLoad: false
});