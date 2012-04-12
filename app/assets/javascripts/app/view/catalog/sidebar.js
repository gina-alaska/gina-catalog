Ext.define('App.view.catalog.sidebar', {
  extend: 'Ext.tab.Panel',
  alias: 'widget.catalog_sidebar',

  autoScroll: true,
  config: { sortHandler: Ext.emptyFn },
  minWidth: 370,
  minTabWidth: 120,
  activeTab: 1,
  plain: true,
  deferredRender: false,
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

    this.projectCount = Ext.widget('menuitem', {
      text: 'Projects: 0'
    });
    this.assetCount = Ext.widget('menuitem', {
      text: 'Data: 0'
    });
    this.uniqueCount = Ext.widget('menuitem', {
      text: 'Unique: 0'
    });
    this.resultCount = Ext.widget('button', {
      text: 'Total Results: 0',
      minWidth: 40,
      menu: [this.uniqueCount, this.projectCount, this.assetCount]
    });
    this.limit_selector = Ext.create('Ext.button.Cycle', {
      prependText: 'Results/Page: ',
      showText: true,
      changeHandler: this.changeHandler,
      menu: {
        items: [{
          text: '100'
        }, {
          text: '200'
        }, {
          text: '500'
        }, {
          text: '1000'
        }, {
          text: '2000',
          checked: true
        }, {
          text: '3000'
        }]
      }
    });
    
    var tb = ['->', this.limit_selector, this.resultCount];

    Ext.apply(this, {
      dockedItems: [{
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        store: this.store,
        items: tb
      },{
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
      items: [{
        itemId: 'filters',
        title: 'Filters',
        layout: 'fit',
        border: false,
        bodyCls: 'myborders',
        items: { xtype: 'filterlist' }
      },{
        itemId: 'results',
        title: 'Search Results',
        layout: 'fit',
        border: false,
        bodyCls: 'myborders',
        items: {
          xtype: 'catalog_list',
          store: this.store
        }
      }]
    });

    this.callParent();
    this.store.on('datachanged', this.onDataChanged, this);
  },
  
  changeHandler: function(cycleBtn, activeItem) {
    var store = cycleBtn.up('catalog_sidebar').store;
    store.pageSize = parseInt(activeItem.text, 10);
    store.loadPage(1);
  },

  onDataChanged: function(store) {
    this.resultCount.setText("Total Results: " + store.getTotalCount());
    var filters = Ext.StoreMgr.lookup('Filters').buildFilterRequest();
    Ext.Ajax.request({
      url: '/catalog/unique',
      params: {
        filter: Ext.JSON.encode(filters)
      },
      scope: this,
      success: function(response) {
        Ext.defer(this.getRecordCounts, 100, this, [Ext.decode(response.responseText)]);
      }
    })
   
  },
  
  getRecordCounts: function(data) {
    this.uniqueCount.setText("Unique: " + (data.unique_total || '0'));
    this.projectCount.setText("Projects: " + (data.projects || '0'));
    this.assetCount.setText("Data: " + (data.assets || '0'));
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
