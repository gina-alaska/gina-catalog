/**
* @class Manager.shared_views.catalog.location_form_panel
* @extends Ext.panel.Panel
* Shared view for location form panel
*/
Ext.define('Manager.shared_views.catalog.location_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_location_form_panel',

  initComponent: function() {
    Ext.apply(this, {
      dockedItems: [{
        xtype:'toolbar', dock: 'top', defaults: { scale: 'large' },
        items: [{ text: '<b>New Location</b>', action: 'add_location' }]
      }]
    });      

    this.callParent(arguments);
  }
});