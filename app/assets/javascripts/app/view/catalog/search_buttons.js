/**
 * @class App.view.catalog.search_buttongroup
 * @extends Ext.container.ButtonGroup
 * Description
 */
Ext.define('App.view.catalog.search_buttons', {
  extend: 'Ext.container.ButtonGroup', 
  alias: 'widget.catalog_search_buttons',

  initComponent: function() {
    Ext.apply(this, {
      defaults: { scale: 'medium' },
      items: [{
        xtype: 'button',
        text: 'Clear Filters',
        action: 'clear_filters',
        iconCls: 'viewall-icon'
      }, {
        xtype: 'button',
        text: 'Filter By',
        iconCls: 'search-icon',
        menu: [{
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
          text: 'Project/Data',
          iconCls: 'type-icon',
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
          text: 'Starting Year',
          field: 'start_date',
          value: 'Start Date',
          action: 'filter',
          filterType: 'dateselector',
          description: 'Starting Year {type} {year}',
          iconCls: 'date-icon'
        }, {
          text: 'Ending Year',
          field: 'end_date',
          value: 'End Date',
          action: 'filter',
          filterType: 'dateselector',
          description: 'Ending Year {type} {year}',
          iconCls: 'date-icon'
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
          action: 'aoi'
        }]
      }]
    });        

    this.callParent(arguments);
  }
});