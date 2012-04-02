Ext.define('App.store.IsoThemes', {
  extend: 'Ext.gina.data.Store',
  model: 'App.model.IsoTheme',
  proxy: {
    type: 'ajax',
    url: '/iso_topics.json',
    timeout: 120000,
    reader: { type: 'json', totalProperty: 'total', root: 'iso_topics' }
  },
  autoLoad: false
});