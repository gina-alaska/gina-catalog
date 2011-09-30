Ext.define('App.view.catalog.sidebar', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.catalogsidebar',

  autoScroll: true,
  config: {
    sortHandler: Ext.emptyFn
  },

  layout: {
    type: 'vbox',
    align: 'stretch'
  },

  initComponent: function() {
    this.addEvents('open', 'showall', 'drawaoi', 'filter');

    this.resultCount = Ext.widget('button', {
      text: '0'
    });

    this.items = [{
      title: 'Search Results',
      flex: 3,
      layout: 'fit',
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        items: ['->', 'Results: ', this.resultCount]
      }],
      items: {
        xtype: 'resultslist'
      }
    }, {
      title: 'Filters',
      flex: 1,
      layout: 'fit',
      margins: '3 0 0 0',
      items: {
        xtype: 'filterlist'
      }
    }];

    this.checkHandler = function(menu, checked) {
      if(checked) {
        var handler = this.getSortHandler(),
            parent = menu.parentMenu.parentItem,
            field = parent.dataIndex,
            dir = menu.text;

        if(dir == 'Ascending') {
          dir = 'ASC';
        } else {
          dir = 'DESC';
        }

        parent.setChecked(true);
        handler(field, dir);
      }
    }

    this.directionMenu = function() {
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
    };

    this.fieldMenu = Ext.create('Ext.menu.Menu', {
      items: [{
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
    });

    this.actions = {};
    this.actions.open = Ext.create('Ext.Action', {
      text: 'View Details',
      scope: this,
      disabled: true,
      iconCls: 'open-icon',
      scale: 'medium',
      handler: function() {
        var selected = this.down('dataview').getSelectionModel().getSelection();
        if(selected[0]) {
          this.fireEvent('open', selected[0]);
        } else {
          //Notify that there is nothing selected
          Ext.gina.Notify.show('Notice', 'No record was selected')
        }
      }
    });

    this.actions.showall = Ext.create('Ext.Action', {
      scale: 'medium', text: 'Show All',
      iconCls: 'viewall-icon',
      scope: this,
      handler: function() {
        this.fireEvent('showall', this);
      }
    });

    this.actions.sort = Ext.create('Ext.Action', {
      text: 'Sort',
      scale: 'medium',
      iconCls: 'sort-icon',
      menu: this.fieldMenu
    });

    this.actions.advanced = Ext.create('Ext.Action', {
      text: 'Filter By',
      scale: 'medium',
      icon: '/images/icons/small/search.png',
      menu: [{
        text: 'Agency',
        iconCls: 'agency-icon',
        scope: this,
        handler: function() {
          this.fireEvent('filter', this, 'agency')
        }
      }, {
        text: 'Contact',
        iconCls: 'contact-icon',
        scope: this,
        handler: function() {
          this.fireEvent('filter', this, 'contact')
        }
      }, {
        text: 'Source',
        iconCls: 'source-icon',
        scope: this,
        handler: function() {
          this.fireEvent('filter', this, 'source')
        }
      }, {
        text: 'Status',
        iconCls: 'status-icon',
        menu: [{
          text: 'Ongoing',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'status', 'ongoing')
          }
        }, {
          text: 'Complete',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'status', 'complete')
          }
        }, {
          text: 'Unknown',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'status', 'unknown')
          }
        }, {
          text: 'Local',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'status', 'local')
          }
        }, {
          text: 'Remote',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'status', 'remote')
          }
        }]
      }, {
        text: 'Project/Data',
        iconCls: 'type-icon',
        menu: [{
          text: 'Project',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'type', 'Project')
          }
        }, {
          text: 'Data',
          scope: this,
          handler: function() {
            this.fireEvent('filter', this, 'string', 'type', 'Asset')
          }
        }]
      }, {
        text: 'Year',
        iconCls: 'date-icon',
        scope: this,
        handler: function() { this.fireEvent('filter', this, 'year'); }
      }]
    });

    this.actions.exportsearch = Ext.create('Ext.Action', {
      scale: 'medium',
      text: 'Export',
      icon: '/images/icons/small/download.png'
    });

    this.actions.regions = Ext.create('Ext.Action', {
      text: 'Region',
      scale: 'medium',
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
    })

    this.callParent();

    this.down('dataview').on('itemdblclick', this.onItemDblClick, this);
    this.down('dataview').on('selectionchange', this.onSelectionChange, this);
  },

  onDataChanged: function(store) {
    this.resultCount.setText(store.getCount());
  },

  onSelectionChange: function(sm, selections, opts) {
    if(selections.length > 0) {
      this.actions.open.enable();

      var dom = sm.view.getNode(selections[0])
      var el = Ext.get(dom);
      el.scrollIntoView(this.body);
    } else {
      this.actions.open.disable();
    }
  },

  onItemDblClick: function(dv, r, node, index) {
    //make sure the record stays selected
    if(r) { dv.select(r); }
    this.fireEvent('open', r);
  }
});
