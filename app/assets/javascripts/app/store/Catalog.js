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
  pageSize: ((Ext.isIE6 || Ext.isIE7 || Ext.isIE8) ? 500 : 2000),
  remoteSort: true,
  remoteFilter: true,
  autoLoad: false
});