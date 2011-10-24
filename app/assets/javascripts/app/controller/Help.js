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
    this.pages = { parent: panel };
  },

  showHelp: function() {
    App.showLoading();
    
    this.pages.index = this.pages.parent.add({ xtype: 'helpindex', border: false });
    this.pages.parent.getLayout().setActiveItem(this.pages.index);
  }
});