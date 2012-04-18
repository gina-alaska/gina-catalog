Ext.define('App.store.Catalog', {
  extend: 'Ext.data.Store',
  
  model: 'App.model.SearchResult',
  proxy: {
    type: 'ajax',
    url: '/search.json',
    method: 'POST',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'results'
    }
  },
  pageSize: (Ext.isIE ? 500 : 20),
  remoteSort: true,
  remoteFilter: true,
  autoLoad: false
});