Ext.define('Manager.store.IsoTopics', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.IsoTopic',
  proxy: {
    url: '/iso_topics.json',
    type: 'ajax',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'iso_topics'
    }
  },  
  autoLoad: true
});