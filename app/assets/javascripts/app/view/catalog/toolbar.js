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
              scope: this,
              handler: function() {
                this.fireEvent('filter', this, 'agency');
              }
            }, {
              text: 'Contact',
              iconCls: 'contact-icon',
              scope: this,
              handler: function() {
                this.fireEvent('filter', this, 'contact');
              }
            }, {
              text: 'Source',
              iconCls: 'source-icon',
              scope: this,
              handler: function() {
                this.fireEvent('filter', this, 'source');
              }
            }, {
              text: 'Status',
              iconCls: 'status-icon',
              menu: [{
                text: 'Ongoing',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'status', 'ongoing');
                }
              }, {
                text: 'Complete',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'status', 'complete');
                }
              }, {
                text: 'Unknown',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'status', 'unknown');
                }
              }, {
                text: 'Local',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'status', 'local');
                }
              }, {
                text: 'Remote',
                scope: this,
                handler: function() {
                  this.fireEvent('filter', this, 'string', 'status', 'remote');
                }
              }]
            }, {
              text: 'Project/Data',
              iconCls: 'type-icon',
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
              scope: this,
              handler: function() { this.fireEvent('filter', this, 'date', 'start_date'); }
            }, {
              text: 'Ending Year',
              iconCls: 'date-icon',
              scope: this,
              handler: function() { this.fireEvent('filter', this, 'date', 'end_date'); }
            }, {
              text: 'Region',
              iconCls: 'region-icon',
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