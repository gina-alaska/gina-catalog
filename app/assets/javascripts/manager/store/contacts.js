Ext.define('Manager.store.Contacts', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.Contact',
  proxy: {
    url: '/people.json',
    type: 'ajax',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'people'
    }
  },  
  sorters: [{ property: 'last_name' }],
  autoLoad: true,
  pageSize: 10000,
  remoteSort: true,
  remoteFilter: true
});