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
            action: 'clear'
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
            iconCls: 'viewall-icon'
          }, {
            xtype: 'button',
            text: 'Filter By',
            iconCls: 'search-icon',
            menu: [{
              text: 'Agency',
              iconCls: 'agency-icon',
              action: 'filter',
              xtype: 'menucheckitem',
              query: 'agencyselector',
              field: 'agency_ids'
            }, {
              text: 'Contact',
              iconCls: 'contact-icon',
              action: 'filter',
              xtype: 'menucheckitem',
              query: 'contactselector',
              field: 'contact_ids'
            }, {
              text: 'Source',
              iconCls: 'source-icon',
              field: 'source',
              xtype: 'menucheckitem',
              query: 'string',
              action: 'filter'
            }, {
              text: 'Status',
              iconCls: 'status-icon',
              xtype: 'menucheckitem',
              menu: [{
                text: 'Ongoing',
                field: 'status',
                query: 'string',
                action: 'filter',
                value: 'ongoing',
                group: 'status', xtype: 'menucheckitem',
                scope: this,
                checkHandler: this.checkHandler
              }, {
                text: 'Complete',
                field: 'status',
                query: 'string',
                action: 'filter',
                value: 'complete',
                group: 'status', xtype: 'menucheckitem',
                scope: this,
                checkHandler: this.checkHandler
              }, {
                text: 'Unknown',
                field: 'status',
                query: 'string',
                action: 'filter',
                value: 'unknown',
                group: 'status', xtype: 'menucheckitem',
                scope: this,
                checkHandler: this.checkHandler
              }, {
                text: 'Local',
                field: 'status',
                query: 'string',
                action: 'filter',
                value: 'local',
                group: 'status', xtype: 'menucheckitem',
                scope: this,
                checkHandler: this.checkHandler
              }, {
                text: 'Remote',
                field: 'status',
                query: 'string',
                action: 'filter',
                value: 'remote',
                group: 'status', xtype: 'menucheckitem',
                scope: this,
                checkHandler: this.checkHandler
              }]
            }, {
              text: 'Project/Data',
              iconCls: 'type-icon',
              xtype: 'menucheckitem',
              menu: [{
                text: 'Project',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'type', 'Project');
                }
              }, {
                text: 'Data',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'type', 'Asset');
                }
              }]
            }, {
              text: 'Starting Year',
              iconCls: 'date-icon',
              xtype: 'menucheckitem',
              scope: this,
              handler: function() { this.fireEvent('filter', this, 'date', 'start_date'); }
            }, {
              text: 'Ending Year',
              iconCls: 'date-icon',
              xtype: 'menucheckitem',
              scope: this,
              handler: function() { this.fireEvent('filter', this, 'date', 'end_date'); }
            }, {
              text: 'Region',
              iconCls: 'region-icon',
              xtype: 'menucheckitem',
              menu: [{
                text: 'Alaska',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'region', 'geokeywords', 'Alaska');
                }
              }, {
                text: 'Northslope',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'region', 'geokeywords', 'Northslope');
                }
              }]
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
            iconCls: 'download-icon'
          }]
        }]
      })

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