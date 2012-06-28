Ext.define('App.model.Filter', {
  extend: 'Ext.data.Model',
  idProperty: 'name',
  fields: [
    'field', 'value', 'desc', 'sort', 'history_id'
  ]
});