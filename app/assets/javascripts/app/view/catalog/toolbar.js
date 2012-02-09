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
            plugins: [new Ext.gina.DefaultText({text: 'Enter search terms here'})],
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
          }, {
            xtype: 'button',
            text: 'Sort',
            iconCls: 'sort-icon',
            menu: [{
              text: 'Title',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("title_sort","Sort by title")
            },{
              text: 'Project/Data',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("type","Sort by project/data")
            },{
              text: 'Source',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("source_agency_acronym","Sort by source agency")
            },{
              text: 'Status',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("status","Sort by status")
            },{
              text: 'Start Date',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("start_date_year","Sort by start date")
            },{
              text: 'End Date',
              group: 'sort', xtype: 'menucheckitem',
              hideOnClick: false,
              menu: this.directionMenu("end_date_year","Sort by end date")
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
    
    directionMenu: function( val, description) {
      return [{
        text: 'Ascending',
        group: 'direction', xtype: 'menucheckitem',
        field: 'order_by',
        action: 'filter',
        filterType: 'single',
        value: val + "-asc",
        description: description + " ascending",
        scope: this,
        checkHandler: this.checkHandler
      }, {
        text: 'Descending',
        group: 'direction', xtype: 'menucheckitem',
        field: 'order_by',
        action: 'filter',
        filterType: 'single',
        value: val + "-desc",
        description: description + " descending",
        scope: this,
        checkHandler: this.checkHandler
      }];
    },
    
    checkHandler: function(menu, checked) {
      if(checked) {
        var parent = menu.parentMenu.parentItem;

        parent.setChecked(true);
      }
    }
});