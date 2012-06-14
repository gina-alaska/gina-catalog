Ext.define('Manager.store.Agencies', {
  extend: 'Ext.data.Store',
  model: 'Manager.model.Agency',
  proxy: {
    type: 'ajax',
    url: '/agencies.json',
    timeout: 120000,
    reader: { type: 'json', totalProperty: 'total', root: 'agencies' }
  },
  sorters: [{ property: 'acronym' }],
  remoteFilter: true,
  remoteSort: true,
  pageSize: 3000,  
  autoLoad: true
});