/**
 * @class App.view.catalog.toolbar
 * @extends Ext.toolbar.Toolbar
 * Filter toolbar for the catalog
 */
Ext.define('App.view.catalog.toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.catalog_toolbar',

    initComponent: function() {
      Ext.apply(this, {
        items: [{
          xtype: 'buttongroup',
          defaults: { scale: 'medium' },
          items: [{
            name: 'q',
            cls: 'quicksearch',
            xtype: 'textfield',
            width: 400
          }, {
            xtype: 'button',
            iconCls: 'cancel-icon',
            action: 'clear_text'
          }, {
            xtype: 'button',
            iconCls: 'search-icon',
            action: 'search'
          }]          
        }, {
          xtype: 'buttongroup',
          defaults: {
            scale: 'medium'
          },
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
              field: 'source_agency_ids',
              description: 'Source Agency: {name}'
            }, {
              text: 'Status',
              iconCls: 'status-icon',
              menu: [{
                text: 'Ongoing',
                field: 'status',
                filterType: 'single',
                action: 'filter',
                value: 'ongoing',
                description: 'Status: Ongoing'
              }, {
                text: 'Complete',
                field: 'status',
                filterType: 'single',
                action: 'filter',
                value: 'complete',
                description: 'Status: Complete'
              }, {
                text: 'Unknown',
                field: 'status',
                filterType: 'single',
                action: 'filter',
                value: 'unknown',
                description: 'Status: Unknown'
              }, {
                text: 'Local',
                field: 'status',
                filterType: 'single',
                action: 'filter',
                value: 'local',
                description: 'Status: Local'
              }, {
                text: 'Remote',
                field: 'status',
                filterType: 'single',
                action: 'filter',
                value: 'remote',
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
          }, {
            xtype: 'button',
            text: 'Sort',
            iconCls: 'sort-icon',
            menu: [{
              text: 'Title',
              dataIndex: 'title',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            },{
              text: 'Project/Data',
              dataIndex: 'type',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            },{
              text: 'Source',
              dataIndex: 'source_agency_acronym',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            },{
              text: 'Status',
              dataIndex: 'status',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            },{
              text: 'Start Date',
              dataIndex: 'start_date_year',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            },{
              text: 'End Date',
              dataIndex: 'end_date_year',
              group: 'sort', xtype: 'menucheckitem',
              menu: this.directionMenu()
            }]
          }, {
            xtype: 'button',
            text: 'Export',
            action: 'export',
            iconCls: 'download-icon'
          }]
        }]
      });

      this.callParent(arguments);
    }, 
    
    directionMenu: function() {
      return [{
        text: 'Ascending',
        group: 'direction', xtype: 'menucheckitem',
        scope: this,
        checkHandler: this.checkHandler
      }, {
        text: 'Descending',
        group: 'direction', xtype: 'menucheckitem',
        scope: this,
        checkHandler: this.checkHandler
      }];
    },
    
    checkHandler: function(menu, checked) {
      if(checked) {
        var parent = menu.parentMenu.parentItem,
            field = parent.dataIndex,
            dir = menu.text;
        
        dir = (dir == 'Ascending' ? 'ASC' : 'DESC');

        parent.setChecked(true);
      }
    }
});