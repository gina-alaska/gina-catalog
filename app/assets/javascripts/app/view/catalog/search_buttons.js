/**
 * @class App.view.catalog.search_buttongroup
 * @extends Ext.container.ButtonGroup
 * Description
 */
Ext.define('App.view.catalog.search_buttons', {
  extend: 'Ext.container.ButtonGroup', 
  alias: 'widget.catalog_search_buttons',

  initComponent: function() {
    var menuitems = [{
      text: 'Agency',
      iconCls: 'agency-icon',
      action: 'filter',
      filterType: 'agencyselector',
      field: 'agency_ids',
      description: 'Agency: {name}'
    }, {
      text: 'Contact',
      iconCls: 'contact-icon',
      action: 'filter',
      filterType: 'contactselector',
      field: 'contact_ids',
      description: 'Contact: {full_name}'
    }, {
      text: 'Data Type',
      iconCls: 'data-icon',
      menu: [{
        text: 'Image',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'image',
        description: 'Data Type: Image'
      }, {
        text: 'Database',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'database',
        description: 'Data Type: Database'
      }, {
        text: 'Report',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'report',
        description: 'Data Type: Report'
      }, {
        text: 'GIS',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'gis',
        description: 'Data Type: GIS'
      }, {
        text: 'Map',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'map',
        description: 'Data Type: Map'
      }, {
        text: 'Web Service',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'web_service',
        description: 'Data Type: Web Service'
      }, {
        text: 'Other',
        action: 'filter',
        filterType: 'multiple',
        field: 'data_type',
        value: 'other',
        description: 'Data Type: Other'
      }]
    }, {
      text: 'ISO Theme',
      iconCls: 'data-icon',
      action: 'filter',
      filterType: 'isothemeselector',
      field: 'iso_theme',
      description: 'ISO Theme: {name}'
    }, {
      text: 'Long Term Monitoring',
      iconCls: 'data-icon',
      menu: [{
        text: 'Yes',
        action: 'filter',
        filterType: 'single',
        field: 'long_term_monitoring',
        value: '1',
        description: 'Long Term Monitoring: Yes'
      }, {
        text: 'No',
        action: 'filter',
        filterType: 'single',
        field: 'long_term_monitoring',
        value: '0',
        description: 'Long Term Monitoring: No'
      }]
      // action: 'filter',
      // filterType: 'contactselector',
      // field: 'contact_ids',
      // description: 'Contact: {full_name}'     
    }, {
      text: 'Project/Data',
      iconCls: 'data-icon',
      menu: [{
        text: 'Project',
        field: 'type',
        value: 'Project',
        action: 'filter',
        filterType: 'single',
        description: 'Show Projects Only'
      }, {
        text: 'Data',
        field: 'type',
        value: 'Asset',
        action: 'filter',
        filterType: 'single',
        description: 'Show Data Only'
      }] 
    }, {
      text: 'Source',
      iconCls: 'source-icon',
      filterType: 'sourceselector',
      action: 'filter',
      field: 'source_agency_id',
      description: 'Source Agency: {name}'
    }, {
      text: 'Status',
      iconCls: 'status-icon',
      menu: [{
        text: 'Ongoing',
        field: 'status',
        filterType: 'single',
        action: 'filter',
        value: 'Ongoing',
        description: 'Status: Ongoing'
      }, {
        text: 'Complete',
        field: 'status',
        filterType: 'single',
        action: 'filter',
        value: 'Complete',
        description: 'Status: Complete'
      }, {
        text: 'Unknown',
        field: 'status',
        filterType: 'single',
        action: 'filter',
        value: 'Unknown',
        description: 'Status: Unknown'
      }, {
        text: 'Local',
        field: 'status',
        filterType: 'single',
        action: 'filter',
        value: 'Local',
        description: 'Status: Local'
      }, {
        text: 'Remote',
        field: 'status',
        filterType: 'single',
        action: 'filter',
        value: 'Remote',
        description: 'Status: Remote'
      }]
    }, {
      text: 'Starting Year',
      field: 'start_date',
      value: 'Start Date',
      action: 'filter',
      filterType: 'dateselector',
      description: 'Starting Year {type} {year}',
      iconCls: 'calendar-icon'
    }, {
      text: 'Ending Year',
      field: 'end_date',
      value: 'End Date',
      action: 'filter',
      filterType: 'dateselector',
      description: 'Ending Year {type} {year}',
      iconCls: 'calendar-icon'
    }, {
      text: 'Region',
      iconCls: 'region-icon',
      menu: [{
        text: 'Alaska',
        field: 'region',
        value: "Alaska",
        action: 'filter',
        filterType: 'single',
        description: 'Region Alaska'
      }, {
        text: 'Northslope',
        field: 'region',
        value: "Northslope Borough",
        action: 'filter',
        filterType: 'single',
        description: 'Region Northslope'
      }]
    }, {
      text: 'AOI',
      action: 'aoi',
      iconCls: 'aoi-icon'
    }];
    
    Ext.apply(this, {
      defaults: { minWidth: 70, scale: 'small', iconAlign: 'top', iconCls: 'contact-icon' },
      cls: 'catalog_search_buttons',
      items: [{
        xtype: 'button',
        text: 'Clear Filters',
        action: 'clear_filters',
        scale: 'small',
        iconCls: 'small-cancel-icon'
      }, {
        iconCls: 'filter-icon',
        text: 'Filter By',
        menu: menuitems
      }]
    });        

    this.callParent(arguments);
  }
});