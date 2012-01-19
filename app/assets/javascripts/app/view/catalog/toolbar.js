/**
 * @class App.view.catalog.toolbar
 * @extends Ext.toolbar.Toolbar
 * Filter toolbar for the catalog
 */
Ext.define('App.view.catalog.toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.catalog_toolbar',

    initComponent: function() {
      Ext.apply(this, {
        items: [{
          xtype: 'buttongroup',
          items: [{
            xtype: 'textfield',
            width: 300
          }, {
            xtype: 'button',
            text: 'Clear'
          }, {
            xtype: 'button',
            text: 'Search'
          }]          
        }, {
          xtype: 'buttongroup',
          items: [{
            xtype: 'button',
            text: 'Clear All Filters'
          }, {
            xtype: 'button',
            text: 'Filter By'
          }, {
            xtype: 'button',
            text: 'Sort'
          }, {
            xtype: 'button',
            text: 'Export'
          }]
        }]
      })

      this.callParent(arguments);
    }
});