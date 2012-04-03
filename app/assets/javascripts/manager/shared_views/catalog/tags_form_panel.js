/**
* @class Manager.shared_views.catalog.tags_form_panel
* @extends Ext.panel.Panel
* Shared view for tag like fields
*/
Ext.define('Manager.shared_views.catalog.tags_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_tags_form_panel',

  initComponent: function() {
    Ext.apply(this, {
      items: [{ xtype: 'textfield', fieldLabel: 'Tags', name: 'tags' }, 
      {
        xtype: 'combobox', fieldLabel: 'Geo-Tags', queryMode: 'local', triggerAction: 'all',
        name: 'geokeyword_ids', multiSelect: true, editable: false, store: 'Geokeywords',
        displayField: 'name', valueField: 'id'
      }, {
        xtype: 'combobox', fieldLabel: 'ISO Topic Category', queryMode: 'local', triggerAction: 'all',
        name: 'iso_topic_ids', multiSelect: true, editable: false, store: 'IsoTopics',
        displayField: 'long_name_with_code', valueField: 'id'
      }, {
        xtype: 'combobox', fieldLabel: 'Data Type', queryMode: 'local', triggerAction: 'all',
        name: 'data_type_ids', multiSelect: true, editable: false, store: 'DataTypes',
        displayField: 'name', valueField: 'id'
      }, { 
        xtype: 'fieldcontainer',
        fieldLabel: 'Long Term Monitoring',
        defaultType: 'radiofield',
        layout: 'hbox',
        items: [{
          flex: 1,
          boxLabel: 'Yes',
          name: 'long_term_monitoring',
          inputValue: true,
          margin: '0 0 0 20'
        },{
          flex: 3,
          boxLabel: 'No',
          name: 'long_term_monitoring',
          inputValue: false,
          checked: true
        }]
      }]
    });

    this.callParent(arguments);
  }
});