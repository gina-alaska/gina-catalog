/**
* @class Manager.shared_views.catalog.contact_form_panel
* @extends Ext.panel.Panel
* Shared Contact Form Panel
*/
Ext.define('Manager.shared_views.catalog.contact_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_contact_form_panel',

  initComponent: function() {
    var primary_contacts = Ext.create('Manager.store.Contacts', { autoLoad: true });
    
    Ext.apply(this, {
      layout: 'anchor',
      items: [{
        xtype: 'combobox', fieldLabel: 'Primary Contact', queryMode: 'remote', triggerAction: 'all',
        minChars: 2, typeAhead: true, name: 'primary_contact_id', store: primary_contacts,
        displayField: 'fullname_with_email', valueField: 'id'
      }, {
        xtype: 'combobox', fieldLabel: 'Other Contacts', queryMode: 'local', triggerAction: 'all',
        name: 'person_ids', multiSelect: true, editable: false, store: 'Contacts',
        displayField: 'fullname_with_email', valueField: 'id'
      }]
    });        

    this.callParent(arguments);
  }
});