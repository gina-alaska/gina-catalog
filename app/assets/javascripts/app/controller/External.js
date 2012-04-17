Ext.define('App.controller.External', {
  extend: 'Ext.app.Controller',

  init: function() {
    this.control({
      'catalog_navigation_toolbar button[action="external"]': {
        click: this.openUrl
      },
      'catalog_navigation_toolbar menuitem[action="external"]': {
        click: this.openUrl
      }      
    });
  },

  openUrl: function(item) {
    window.open(item.link);
  }
});