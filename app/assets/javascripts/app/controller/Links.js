Ext.define('App.controller.Links', {
  extend: 'Ext.app.Controller',

  init: function() {
    this.control({
      'catalog_navigation_toolbar button[action="external"]': {
        click: this.openExternalUrl
      },
      'catalog_navigation_toolbar menuitem[action="external"]': {
        click: this.openExternalUrl
      },
      'catalog_navigation_toolbar button[action="local"]': {
        click: this.openUrl
      },
      'catalog_navigation_toolbar menuitem[action="local"]': {
        click: this.openUrl
      }      
    });
  },

  openUrl: function(item) {
    top.location = item.link;
  },

  openExternalUrl: function(item) {
    window.open(item.link);
  }
});