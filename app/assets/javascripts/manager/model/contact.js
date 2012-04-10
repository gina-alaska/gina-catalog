Ext.define('Manager.model.Contact', {
  extend: 'Ext.data.Model',
  fields: [ 'id', 'first_name', 'last_name', 'email', 'full_name', 'agencies', 'authorized?', {
    name: 'fullname_with_email',
    convert: function(v,r){
      var fwe = r.get('full_name');
      if (r.get('email')) {
        fwe += ' ('+r.get('email')+')'; 
      } 
      return fwe;
    } 
  } ]
});