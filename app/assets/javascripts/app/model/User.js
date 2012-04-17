Ext.define('App.model.User', {
  extend: 'Ext.data.Model',

  proxy: {
    type: 'ajax',
    url: '/users/preferences.json',
    reader: { type: 'json', root: 'user' }
  },

  fields: [
    'id', 'first_name', 'last_name', 'email',
    'identity_url', 'admin?', 'authorized?', 'guest?', 'fullname'
  ]
});