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
  			edit: this.editLocation
  		},
			'location_window button[action="point"]': {
				editLocation: this.drawPoint
			},
			'location_window button[action="polygon"]': {
				editLocation: this.drawPolygon
			} 
  	});
  },
  editLocation: function(field){
  	var win = Ext.widget('location_window');
  	win.show();
  },
  drawPoint: function(button){
  	console.log(button);
  },
  drawPolygon: function(button){
  	console.log(button);
  }
});