/**
 * @class Manager.shared_views.catalog.agency_form_panel
 * @extends Ext.panel.Panel
 * Shared view for agency forms
 */
Ext.define('Manager.shared_views.catalog.agency_form_panel', {
    extend: 'Ext.panel.Panel', 
    alias: 'widget.catalog_agency_form_panel',

    initComponent: function() {
      var source_agencies = Ext.create('Manager.store.Agencies', { autoLoad: true });
      
      Ext.apply(this, {
        layout: 'anchor',
        items: [{
          xtype: 'combobox', fieldLabel: 'Primary Agency', queryMode: 'remote', triggerAction: 'all',
          minChars: 3, typeAhead: true, name: 'source_agency_id', store: source_agencies,
          displayField: 'name_with_acronym', valueField: 'id' 
        }, {
          xtype: 'combobox', fieldLabel: 'Other Agencies', queryMode: 'local', triggerAction: 'all',
          editable: false, minChars: 3, name: 'agency_ids', store: 'Agencies', displayField: 'name_with_acronym',
          multiSelect: true, valueField: 'id'
        }]
      });        

      this.callParent(arguments);
    }
});