Ext.define('Manager.store.Projects', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.Catalog',
  proxy: {
    url: '/search.json',
    type: 'ajax',
    actionMethods: { read: 'POST' },
    extraParams: {
      "search[type]": "Project"
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