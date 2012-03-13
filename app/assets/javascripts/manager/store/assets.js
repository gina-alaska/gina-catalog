Ext.define('Manager.store.Assets', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.Catalog',
  proxy: {
    url: '/data.json',
    type: 'ajax',
    actionMethods: { read: 'POST' },
    extraParams: {
      "search[type]": "Asset"
    },
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'results'
    }
  },
  
  remoteSort: true,
  remoteFilter: true,
  autoLoad: false
});