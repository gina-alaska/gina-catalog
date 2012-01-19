Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

  views:  [ 'catalog.*'],
  stores: ['SearchResults', 'Filters'],
  models: ['SearchResult', 'Filter'],

  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > #center': {
        render: this.start
      },
    });
  },
  
  show: function() {
    var panel = this.catalogPanel.up('panel');
    panel.getLayout().setActiveItem(this.catalogPanel);
  },
  
  start: function(panel) {
    

    this.catalogPanel = panel.add({
      layout: 'border',
      defaults: { border: false },
      items: [{
        region: 'west',
        width: 300,
        split: true,
        xtype: 'catalog_sidebar'
      }, {
        region: 'center',
        xtype: 'catalog_map'
      }]
    });
  }
});