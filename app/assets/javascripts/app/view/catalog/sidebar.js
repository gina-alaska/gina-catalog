Ext.define('App.view.catalog.sidebar', {
  extend: 'Ext.tab.Panel',
  alias: 'widget.catalog_sidebar',

  autoScroll: true,
  config: { sortHandler: Ext.emptyFn },
  minWidth: 370,
  minTabWidth: 120,
  activeTab: 1,
  plain: true,
  layout: {
    type: 'vbox',
    align: 'stretch'
  },
  dockedItems: [{
    xtype: 'toolbar',
    dock: 'top',
    cls: 'myborders',
    items: [{
      flex: 1,
      name: 'q',
      cls: 'quicksearch',
      xtype: 'textfield',
      hideLabel: true,
      plugins: [new Ext.gina.DefaultText({text: 'Enter search terms here'})]
    },{
      xtype: 'catalog_text_search'
    }]
  }, {
    xtype: 'toolbar',
    cls: 'myborders',
    dock: 'top',
    items: [{ xtype: 'catalog_search_buttons' },{ xtype: 'catalog_other_buttons' }]
  }],
  
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
      itemId: 'filters',
      title: 'Filters',
      layout: 'fit',
      border: false,
      bodyCls: 'myborders',
      items: { xtype: 'filterlist' },
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        layout: { type: 'hbox', pack: 'end' },
        items: [{
          xtype: 'button',
          text: 'Clear Filters',
          action: 'clear_filters',
          scale: 'large',
          iconCls: 'cancel-icon'
        },{ 
          xtype: 'button', 
          text: 'Apply Search Filters &rarr;', 
          disabled: true,
          cls: 'apply',
          icon: '/assets/icons/medium/search.png',
          action: 'apply', 
          scale: 'large'
        }]
      }]
    },{
      itemId: 'results',
      title: 'Search Results',
      layout: 'fit',
      border: false,
      bodyCls: 'myborders',
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        items: tb
      }],
      items: {
        xtype: 'catalog_list',
        store: this.store
      }
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
