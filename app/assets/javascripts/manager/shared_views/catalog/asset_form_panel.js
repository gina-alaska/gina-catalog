/**
* @class Manager.view.shared_views.catalog.asset_form_panel
* @extends Ext.panel.Panel
* General form fields
*/
Ext.define('Manager.shared_views.catalog.asset_form_panel', {
	extend: 'Ext.panel.Panel', 
	alias: 'widget.catalog_asset_form_panel',

	initComponent: function() {
	  Ext.apply(this, {
	    layout: 'anchor',
	    items: [
	      { xtype: 'hiddenfield', name: 'type', value: 'Asset' },
	      { xtype: 'textfield', fieldLabel: 'Title', name: 'title' }, 
	      { xtype: 'textarea', fieldLabel: 'Description', name: 'description', height: 180 }
	    ]
	  });        

	  this.callParent(arguments);
	}
});