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
      defaults: { minWidth: 60, iconAlign: 'top', scale: 'small' },
      
      items: [{
        xtype: 'button',
        text: 'Export',
		menu: [{
			text: 'PDF',
			action: 'export'
		}, {
			text: 'HTML',
			action: 'export-html'
		}, {
			text: 'CSV',
			action: 'export-csv'
		}],
        iconCls: 'small-download'
      }, {
        xtype: 'button',
        text: 'Help',
        action: 'filter-help',
        iconCls: 'small-help'
      }]
    });        

    this.callParent(arguments);
  }
});