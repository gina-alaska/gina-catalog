/**
 * @class Manager.shared_views.catalog.location_trigger_field
 * @extends Ext.form.fields.Trigger
 * Location Trigger Field
 */
Ext.define('Manager.shared_views.catalog.location_triggerfield', {
  extend: 'Ext.form.field.Trigger', 
  alias: 'widget.location_triggerfield',

  initComponent: function(){
  	this.addEvents('edit');

  	this.callParent();
  },

  onTriggerClick: function() {
  	this.fireEvent('edit', this, this.getValue());
  }
});