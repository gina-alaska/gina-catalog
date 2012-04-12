/**
 * @class Manager.controller.Location
 * @extends Ext.app.Controller
 * Location window controller
 */
Ext.define('Manager.controller.Location', {
  extend: 'Ext.app.Controller',

  init: function() {
  	this.control({
  		'location_triggerfield': {
  			edit: this.editLocation,
        focus: this.editLocation
  		},
			'location_window': {
				save: function(win, wkt) { win.field.setValue(wkt); win.close(); }
			} 
  	});
  },
  editLocation: function(field){
  	var win = Ext.widget('location_window', { field: field });
  	win.show();
  }
});