Ext.define('App.store.Agencies', {
  extend: 'Ext.gina.data.Store',
  model: 'App.model.Agency',
  proxy: {
    type: 'ajax',
    url: '/agencies.json',
    timeout: 120000,
    reader: { type: 'json', totalProperty: 'total', root: 'agencies' }
  },
  pageSize: 3000,
  autoLoad: false
});