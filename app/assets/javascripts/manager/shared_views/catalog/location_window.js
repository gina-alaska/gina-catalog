/**
 * @class Manager.shared_views.catalog.LocationWindow
 * @extends Ext.window.Window
 * Window for editing locations
 */
Ext.define('Manager.shared_views.catalog.LocationWindow', {
  extend: 'Ext.window.Window', 
  alias: 'widget.location_window',

  initComponent: function() {
    Ext.apply(this, {
    	title: 'Edit Location',
    	width: 600,
    	height: 600,
    	layout: 'fit',
    	dockedItems: [{
    		ui: 'footer',
    		dock: 'bottom',
    		xtype: 'toolbar',
    		defaults: { scale: 'large', width: 50 },
    		items: ['->', { 
    			text: 'Cancel', 
    			handler: function() { 
    				this.up('window').close(); 
    			} 
    		}, { 
    			text: 'Save', action: 'save_location' 
    		}]
    	}, {
    		dock: 'top',
    		xtype: 'toolbar',
    		items: [
    			{ text: 'Point', toggleGroup: 'geom', iconCls: 'point-icon', action: 'point' }, 
    			{ text: 'Polygon', toggleGroup: 'geom', iconCls: 'polygon-icon', action: 'polygon' }
    		]
    	}],
    	items: [{
	  		xtype: 'openlayers',
	  		border: false,
	  		projection: 'EPSG:3338'
    	}]
    });        

    this.callParent(arguments);
  }
});