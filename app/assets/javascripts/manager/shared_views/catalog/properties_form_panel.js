/**
* @class Manager.shared_views.catalog.properties_form_panel
* @extends Ext.panel.Panel
* Shared catalog properties form panel
*/
Ext.define('Manager.shared_views.catalog.properties_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_properties_form_panel',

  initComponent: function() {
    Ext.apply(this, {
      items: [
        { xtype: 'datefield', fieldLabel: 'Start Date', name: 'start_date', anchor: '100%', format: 'Y/m/d' },
        { xtype: 'datefield', fieldLabel: 'End Date', name: 'end_date', anchor: '100%', format: 'Y/m/d' },
        {
          xtype: 'combobox', fieldLabel: 'Status', name: 'status', queryMode: 'local',
          store: this.statusStore,  displayField: 'status', valueField: 'status'
        }, {
          xtype: 'textfield', fieldLabel: 'Data Source', queryMode: 'remote', queryDelay: 100,
          triggerAction: 'all', minChars: 2, typeAhead: true, name: 'data_source_id', store: 'DataSources',
          displayField: 'name', valueField: 'id', disabled: true
        }, {
          xtype: 'combobox', fieldLabel: 'Owner', queryMode: 'remote', queryDelay: 100,
          triggerAction: 'all', minChars: 2, typeAhead: true, name: 'owner_id', store: 'Users',
          displayField: 'fullname_with_email', valueField: 'id'
        }
      ]
    });

    this.callParent(arguments);
  }
});