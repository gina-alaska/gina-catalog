Ext.define('Manager.store.Geokeywords', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.Geokeyword',
  proxy: {
    url: '/geokeywords.json',
    type: 'ajax',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'geokeywords'
    }
  },  
  autoLoad: true
});