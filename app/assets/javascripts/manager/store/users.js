Ext.define('Manager.store.Users', {
  extend: 'Ext.data.Store',
  
  model: 'Manager.model.User',
  proxy: {
    url: '/users.json',
    type: 'ajax',
    timeout: 120000,
    reader: {
      type: 'json',
      totalProperty: 'total',
      root: 'users'
    }
  },  
  autoLoad: true
});