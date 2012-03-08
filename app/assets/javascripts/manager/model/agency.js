Ext.define('Manager.model.Agency', {
  extend: 'Ext.data.Model',
  fields: [ 'id', 'name', 'acronym', 'category', { 
    name: 'name_with_acronym', convert: function(v, r) {
      return r.get('acronym') + ' - ' + r.get('name'); 
    }
  }]
});