Ext.define('App.controller.Video', {
  extend: 'Ext.app.Controller',

  views: ['video.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.setup
      }
    });
  },

  setup: function(parent) {
    this.pages = {};
    this.pages.index = parent.add({ xtype: 'videoindex' });
  },
  
  show: function() {
    this.pages.index.add({xtype: 'panel', contentEl: 'video', border: false});
    this.pages.index.up('panel').getLayout().setActiveItem(this.pages.index);
  }
});