App.stores.add('search_results', {
  storeId: 'search_results',
  fields: App.model('search_result'),
  proxy: new Ext.data.HttpProxy({
    url: '/catalog/search.json',
    method: 'POST',
    timeout: 120000
  }),
  baseParams: { start: 0, limit: 100 },
  root: 'results',
  remoteSort: false,
  totalProperty: 'total',
  autoLoad: false,
  listeners: {
    exception: Ext.ux.StoreHandlers.failure
  }
});