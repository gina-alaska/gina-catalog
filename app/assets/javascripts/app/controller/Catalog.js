Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',


  stores: ['Catalog', 'Filters'],

  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > #center': {
        render: this.start
      } 
    });
  },
  
  show: function() {
    var panel = this.catalogPanel.up('panel');
    panel.getLayout().setActiveItem(this.catalogPanel);
    
    // this.getStore('Catalog').on('beforeload', this.updateFilters, this);
    this.getStore('Catalog').load();
  },
  
  start: function(panel) {
    this.catalogPanel = panel.add({
      id: 'catalog',
      layout: 'border',
      defaults: { border: false },
      dockedItems: [{
        xtype: 'catalog_toolbar',
        dock: 'top'
      }],
      items: [{
        region: 'west',
        width: 300,
        split: true,
        xtype: 'catalog_sidebar',
        store: this.getStore('Catalog')
      }, {
        region: 'center',
        xtype: 'catalog_map',
        dockedItems: [{
          dock: 'bottom',
          xtype: 'catalog_maptoolbar'
        }]
      }]
    });
  }
});