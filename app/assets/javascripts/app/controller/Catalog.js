Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

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
      dockedItems: [{
        xtype: 'catalog_toolbar',
        dock: 'top'
      }],
      items: [{
        region: 'west',
        width: 300,
        split: true,
        xtype: 'catalog_sidebar'
      }, {
        region: 'center',
        xtype: 'panel',
        html: 'map goes here'
      }]
    });
  }
});