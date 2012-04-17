Ext.define('App.controller.News', {
  extend: 'Ext.app.Controller',

  views: ['news.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      },
      'catalog_navigation_toolbar button[text="News"]': {
        click: this.show
      },
      'viewport > #center newsindex': {
        show: App.hideLoading
      }
    });
  },

  start: function(panel) {
    this.pages = { parent: panel };
  },

  show: function() {
    App.showLoading();

    this.pages.index = this.pages.parent.add({ 
      xtype: 'newsindex', border: false 
    });
    this.pages.parent.getLayout().setActiveItem(this.pages.index);
  }
});