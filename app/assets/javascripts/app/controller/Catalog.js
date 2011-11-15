Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

  views: ['catalog.index', 'catalog.list', 'catalog.map', 'catalog.show', 'catalog.sidebar', 'catalog.splash'],
  
  stores: ['SearchResults', 'Filters'],
  models: ['SearchResult', 'Filter'],

  init: function() {
    this.addEvents('featuresrendered');
    
    this.control({
      /* Main viewport events */
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Catalog"]': {
        click: this.show
      },
      /* Search result events */
      'viewport > #center catalogsidebar resultslist': {
        selectionchange: this.onRecordSelect
      },
      'viewport > #center catalogsidebar': {
        "export": this.onExport
      },
      /* Map events */
      'viewport > #center #results-map': {
        ready: this.onMapReady,
        featuresrendered: function(map) { this.fireEvent('featuresrendered', map); }
      },
      /* Asset show events */
      'viewport > #center assetdetails': {
        back: this.show
      }
    });
  },

  start: function(panel) {
    this.pages = {};

    this.pages.map = Ext.create('catalog.map', {
      id: 'results-map',
      flex: 1,
      region: 'center',
      projection: 'EPSG:3572',
      border: true,
      margins: '3 0 3 0',
      store: this.getStore('SearchResults'),
      hideMapToolHeaders: true
    });

    var sorter = function(field, dir) {
      this.showFilterPbar('Sorting results...');
      Ext.defer(this.getStore('SearchResults').sort, 100, this.getStore('SearchResults'), [field, dir]);
    };

    this.pages.sidebar = Ext.widget('catalogsidebar', {
      border: false,
      region: 'west',
      width: 350,
      margins: '3 0 3 3',
      split: true,
      sortHandler: Ext.bind(sorter, this)
    });

    var quickSearch = Ext.create('Ext.gina.QuickSearch', {
      store: this.getStore('SearchResults'),
      maskEl: this.pages.sidebar.id
    });
    this.getStore('SearchResults').on('removefilter', function(store, name) {
      if(name == 'string' || name == 'all') {
        this.clear(true);
      }
    }, quickSearch);
    this.getStore('SearchResults').on('datachanged',
      this.pages.sidebar.onDataChanged, this.pages.sidebar);

    var sb = this.pages.sidebar;
    
    this.pages.index = panel.add({
      layout: 'border',
      border: false,
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'top',
        items: [quickSearch, {
          xtype: 'buttongroup',
          items: [
            sb.actions.showall, sb.actions.advanced, sb.actions.regions,  
            sb.actions.sort, sb.actions.exportsearch
          ]
        }]
      }],
      items: [this.pages.map, this.pages.sidebar]
    });
  },
  
  onExport: function() {
    var store = this.getStore('SearchResults');
    var fields = [];
    var index = 0;
    var limit = 200;

    if (store.getCount() > limit) {
      Ext.MessageBox.alert(
        'Notice',
        'Cannot export more than ' + limit + ' results, please narrow your search.'
      );
      return false;
    }

    store.each(function(i) {
      fields.push({
        xtype: 'hiddenfield', name: 'ids[]', value: i.get('id')
      });
    }, this);

    var win = Ext.create('Ext.window.Window', {
      width: 500,
      height: 200,
      layout: {
        type: 'vbox',
        align: 'stretch'
      },
      items: [{
        flex: 1,
        border: false,
        bodyStyle: 'text-align: center; font-size: 2em; padding: 15px;',
        html: '<h1>Exporting results to PDF, please wait...</h1>'
      },{
        border: false,
        xtype: 'form',
        standardSubmit: true,
        url: '/catalog/search.pdf',
        method: 'POST',
        target: '_blank',
        items: fields
      }]
    });
    
    win.show();
    win.down('form').submit({
      "params": { "limit": limit }
    });
  },

  show: function() {
    /* Only load if it hasn't been loaded already */
    if(!this.getStore('SearchResults').getTotalCount()) {
      this.getStore('SearchResults').load();      
    }
      
    this.getStore('SearchResults').clearCachedFilter('name', 'hideall');

    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  },

  onMapReady: function(map) {
    map.store = Ext.data.StoreManager.get('SearchResults');
    map.setup();
    
    map.tools = new OpenLayers.Control.Panel({
      defaultControl: map.dragPanControl
    });
    map.tools.addControls([map.control('aoi'), map.zoomOutBoxControl, map.zoomInBoxControl, map.dragPanControl]);
    map.controls.add('toolbar', map.tools);

    map.store.on('datachanged', function() {
      this.showFilterPbar('Adding locations to the map');
      Ext.defer(map.showAllFeatures, 100, map);
    }, this, { buffer: 300 });
    map.showAllFeatures();
  },

  onRecordSelect: function(list, selections, options) {
    var map = this.pages.map;
    
    var r = selections[0];
    if(this.lastSelected != r) {
      if(r) { map.showSelectedFeature(r.get('id')); }
      else { map.showAllFeatures(); }
    }
    this.lastSelected = r;
  },
  
  showFilterPbar: function(msg) {
    return Ext.Msg.show({
      title: 'Please wait...',
      msg: msg || 'Filtering records',
      minWidth: 300,
      wait: true,
      modal: false
    });
  }
});
