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
        click: function() { this.showHelp(); }
      },
      'viewport > #center button[action="filter-help"]': {
        click: function() {
          this.showHelp('http://catalog.northslope.org/cms/help/searches-and-filters');
        }
      },
      'viewport > #center helpindex': {
        show: App.hideLoading
      }
    });
  },

  start: function(panel) {
    this.pages = { parent: panel };
  },

  showHelp: function(url) {
    App.showLoading();
    
    this.pages.index = this.pages.parent.add({ xtype: 'helpindex', border: false, url: url });
    this.pages.parent.getLayout().setActiveItem(this.pages.index);
  }
});