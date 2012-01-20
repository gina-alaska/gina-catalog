Ext.define('App.model.Filter', {
  extend: 'Ext.data.Model',
  idProperty: 'name',
  fields: [
    'name', 'value', 'desc'
  ]
});