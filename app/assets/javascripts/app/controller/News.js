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
      'viewport > #center button[text="News"]': {
        click: this.show
      },
      'viewport > #center newsindex': {
        show: App.hideLoading
      }
    });
  },

  start: function(panel) {
    this.pages = {};
    this.pages.index = panel.add({ xtype: 'newsindex', border: false });
  },

  show: function() {
    App.showLoading();

    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  }
});