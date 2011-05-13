Ext.ux.User = function(config) {
  config = config || {};

  this.initialConfig = config;
  Ext.apply(this, config);

  this.addEvents(
  /**
   * @event load
   * Fires after the user information is loaded
   */
    'load',
  /**
   * @event clear
   * Fires after the user has been logged out of the system
   */
    'clear'
  );

  Ext.ux.User.superclass.constructor.call(this);

  this.initComponent();
  this.load();

}
Ext.extend(Ext.ux.User, Ext.util.Observable, {
  /* //protected
   * Function to be implemented by NavigationHandler subclasses, it is empty by default.
   */
  initComponent: Ext.emptyFn,

  url: false,
  method: 'GET',
  
  load: function() {
    if(this.url) {
      Ext.ux.Ajax.request({
        url: this.url,
        method: this.method,
        listeners: {
          scope: this,
          success: this.onLoad,
          forbidden: this.clear
        }
      })
    }
  },

  onLoad: function(xhr, opts, results) {
    if(results.user !== false && results.user !== null) {
      this.data = results.user || [];
      this.is_an_admin = this.data["admin?"];
      this.fireEvent('load', this);
    } else {
      this.clear();
    }
  },

  clear: function() {
    this.data = false;
    this.is_an_admin = false;
    this.fireEvent('clear', this);
  },
  
  "logged_in": function() {
    return this.data !== false;
  },

  get: function(field) {
    return this.data[field];
  }
});