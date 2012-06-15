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

    this.location_count = 0;
    this.callParent(arguments);
  },
  
  reset: function() {
    this.removeAll();
    this.location_count = 0;
  },
  
  buildLocation: function(loc){
    Ext.applyIf(loc, {
      id: '',
      name: '',
      wkt: ''
    });
    
    var loc_markup = {
      xtype: 'fieldcontainer',
      role: 'location',
      layout: { type: 'hbox', defaultMargins: { right: 3 } },
      fieldDefaults: { labelAlign: 'top' },
      items: [{
        xtype: 'hiddenfield', name: 'locations_attributes['+this.location_count+'][id]', value: loc.id
      }, {
        xtype: 'textfield', fieldLabel: 'Label', flex: 3,
        name: 'locations_attributes['+ this.location_count +'][name]', value: loc.name
      }, {
        xtype: 'location_triggerfield', fieldLabel: 'Geom', flex: 10,
        name: 'locations_attributes['+ this.location_count + '][wkt]', value: loc.wkt
      }, {
        xtype: 'fieldcontainer',
        layout: 'hbox',
        flex: 1,
        fieldLabel: 'Actions',
        items: [{
          xtype: 'button', text: 'Remove', flex: 1, action: 'remove_location', locId: loc.id
        }]
      }]
    };        
    this.location_count += 1;
    
    return loc_markup;
  },
  addLocation: function(loc){
    this.add(this.buildLocation(loc));      
  }
});