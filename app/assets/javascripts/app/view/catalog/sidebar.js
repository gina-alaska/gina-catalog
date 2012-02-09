Ext.define('App.view.catalog.sidebar', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.catalog_sidebar',

  autoScroll: true,
  config: { sortHandler: Ext.emptyFn },

  layout: {
    type: 'vbox',
    align: 'stretch'
  },
  
  constructor: function(config){
    this.initConfig(config);
    this.callParent(arguments);
  },

  initComponent: function() {
    this.addEvents('open', 'showall', 'drawaoi', 'filter', 'export');

    this.resultCount = Ext.widget('button', {
      text: '0',
      minWidth: 40
    });
    
    
    var tb;
    if(Ext.isIE) {
      tb = ['->', 'Results:', this.resultCount];
    } else {
      this.projectCount = Ext.widget('button', {
        text: '0',
        minWidth: 40
      });
      this.assetCount = Ext.widget('button', {
        text: '0',
        minWidth: 40
      });
      tb = ['->', 'Projects:', this.projectCount, 'Data:', this.assetCount, 'Results:', this.resultCount];
    }

    this.items = [{
      title: 'Search Results',
      flex: 3,
      layout: 'fit',
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        items: tb
      }],
      items: {
        xtype: 'catalog_list',
        store: this.store
      }
    }, {
      title: 'Filters',
      flex: 1,
      layout: 'fit',
      margins: '3 0 0 0',
      collapsible: true,
      items: {
        xtype: 'filterlist'
      },
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        layout: { type: 'hbox', pack: 'end' },
        items: [{ 
          xtype: 'button', 
          text: 'Apply Search Filters', 
          disabled: true,
          icon: '/assets/icons/medium/search.png',
          action: 'search', 
          scale: 'large'
        }]
      }]
    }];

    this.callParent();
      
    this.store.on('datachanged', this.onDataChanged, this);
  },

  onDataChanged: function(store) {
    this.resultCount.setText(store.getCount());
    Ext.defer(this.getRecordCounts, 100, this, [store]);
  },
  
  getRecordCounts: function(store){
    /* This is disabled in IE */
    if(Ext.isIE) { return false; }
    
    var projects = 0,
        assets = 0,
        titles = [];
    
    store.each(function(i) {
      switch(i.get('type')) {
        case 'Project':
          if(titles.indexOf(i.get('title')) < 0) {
            projects += 1;
            titles.push(i.get('title'));
          }
          break;
        case 'Asset':
          if(titles.indexOf(i.get('title')) < 0) {
            assets += 1;
            titles.push(i.get('title'));
          }
          break;          
      }
    }, this);
    
    this.projectCount.setText(projects || '0');
    this.assetCount.setText(assets || '0');
  },

  onSelectionChange: function(sm, selections, opts) {
    if(selections.length > 0) {
      this.actions.open.enable();

      var dom = sm.view.getNode(selections[0]);
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
