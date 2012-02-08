Ext.define('App.controller.Video', {
  extend: 'Ext.app.Controller',

  views: ['video.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.setup
      },
      'catalog_splash button[action="quickstart"]': {
        click: this.show
      }
    });
  },

  setup: function(parent) {
    this.pages = {};
    this.pages.index = parent.add({ xtype: 'videoindex' });
  },
  
  show: function() {
    this.pages.index.up('panel').getLayout().setActiveItem(this.pages.index);
    this.pages.index.add({
      xtype: 'panel', 
      loader: {
        autoLoad: true,
        url: '/videos/quickstart'
      }, 
      border: false
    });
  }
});
