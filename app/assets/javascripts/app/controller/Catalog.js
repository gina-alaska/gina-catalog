Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

  stores: ['Catalog', 'Filters'],

  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Catalog"]': {
        click: this.show
      }
    });
  },

  show: function() {
    var panel = this.catalogPanel.up('panel');
    panel.getLayout().setActiveItem(this.catalogPanel);

    // this.getStore('Catalog').on('beforeload', this.updateFilters, this);
    if(!this.loaded) {
      this.getStore('Catalog').load();
      this.loaded = true;
    }
  },
  
  start: function(panel) {
    this.catalogPanel = panel.add({
      itemId: 'catalog',
      layout: 'border',
      border: false,
      defaults: { border: false },
      items: [{
        region: 'west',
        width: 500,
        margin: '3px',
        // style: 'border-width: 1px; border-style: solid;',
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
    // this.show();
  }
});