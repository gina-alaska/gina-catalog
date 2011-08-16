Ext.define('App.controller.Help', {
  extend: 'Ext.app.Controller',

  views: ['help.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Help"]': {
        click: this.showHelp
      },
      'viewport > #center helpindex': {
        show: App.hideLoading
      }
    });
  },

  start: function(panel) {
    this.pages = {};
    this.pages.index = panel.add({
      xtype: 'helpindex',
      html: 'Help goes here'
    });
  },

  showHelp: function() {
    App.showLoading();
    
    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  }
});