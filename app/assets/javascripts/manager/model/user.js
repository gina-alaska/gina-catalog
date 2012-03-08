Ext.define('Manager.model.User', {
  extend: 'Ext.data.Model',
  fields: [ 'id', 'first_name', 'last_name', 'email', 'fullname', 'authorized?', {
    name: 'fullname_with_email',
    convert: function(v,r){
      return r.get('fullname') + ' ('+r.get('email')+')'; 
    } 
  } ]
});