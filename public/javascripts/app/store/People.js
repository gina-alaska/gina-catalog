Ext.define('App.store.People', {
  extend: 'Ext.gina.data.Store',
  model: 'App.model.Person',
  proxy: {
    type: 'ajax',
    url: '/people.json',
    timeout: 120000,
    reader: { type: 'json', totalProperty: 'total', root: 'people' }
  },
  autoLoad: false
});