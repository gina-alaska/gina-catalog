Ext.define('Ext.gina.CurrentUser', {
  extend: 'Ext.util.Observable',

  model: 'App.model.User',
  loaded: false,
  
  constructor: function() {
    this.callParent(arguments);

    this.addEvents('load', 'logged_in', 'logged_out');

    this.model = Ext.ModelManager.getModel(this.model);
    this.load();
  },

  onLoad: function(user) {
    if(user === undefined) {
      this.fireEvent('logged_out', this);
    } else {
      this.user = user;
      this.fireEvent('logged_in', this);
    }
    this.loaded = true;
    this.fireEvent('load', this, user);
  },

  isLoggedIn: function() {
    return this.user == undefined;
  },

  load: function() {
    this.model.load(null, {
      scope: this,
      success: this.onLoad
    });
  },

  get: function(field) {
    return this.user.get(field);
  }
});