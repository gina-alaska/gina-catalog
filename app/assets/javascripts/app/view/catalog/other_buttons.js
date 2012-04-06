/**
 * @class App.view.catalog.other_buttons
 * @extends Ext.container.ButtonGroup
 * Description
 */
Ext.define('App.view.catalog.other_buttons', {
  extend: 'Ext.container.ButtonGroup', 
  alias: 'widget.catalog_other_buttons',

  initComponent: function() {
    Ext.apply(this, {
      defaults: { minWidth: 70, iconAlign: 'top', scale: 'small' },
      
      items: [{
        xtype: 'button',
        text: 'Export',
        action: 'export',
        iconCls: 'download-icon'
      }]
    });        

    this.callParent(arguments);
  }
});