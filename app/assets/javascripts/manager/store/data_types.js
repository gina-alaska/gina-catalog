Ext.define('Manager.store.DataTypes', {
  extend: 'Ext.data.Store',
  model: 'Manager.model.DataType',
  proxy: {
    type: 'ajax',
    url: '/data_types.json',
    timeout: 120000,
    reader: { type: 'json', totalProperty: 'total', root: 'data_types' }
  },
  sorters: [{ property: 'name' }],
  remoteFilter: true,
  remoteSort: true,
  autoLoad: true
});