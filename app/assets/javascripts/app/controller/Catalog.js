Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

  views: ['catalog.index', 'catalog.list', 'catalog.map', 'catalog.show', 'catalog.sidebar', 'catalog.splash'],
  
  stores: ['SearchResults', 'Filters'],
  models: ['SearchResult', 'Filter'],

  init: function() {
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
      /* Search filter events */
      'viewport > #center catalogsidebar filterlist': {
        itemclick: this.onFilterClick
      },
      /* Sidebar events */
      'viewport > #center catalogsidebar': {
        showall: this.showAllRecords,
        drawaoi: function() { this.pages.map.aoiHandler(true); },
        filter: this.filterHandler,
        export: this.onExport
      },
      /* Map events */
      'viewport > #center #results-map': {
        ready: this.onMapReady,
        clusterclick: this.onClusterClick,
        aoiadded: this.onAoiAdd
      },
      /* Asset show events */
      'viewport > #center assetdetails': {
        back: this.show
      }
    })
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
      height: 45,
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

//    Ext.gina.Ajax.request({
//      url: '/catalog/search.pdf',
//      method: 'POST',
//      params: {
//        "ids": ids,
//        limit: 100
//      }
//    });
  },

  filterHandler: function(panel, type, field, value) {
    var config,
        store = this.getStore('SearchResults');

    switch(type) {
      case 'string':
        this.showFilterPbar();
        config = this.stringFilterConfig(field, value);
        Ext.defer(store.addStringFilter, 100, store, [config]);
        break;
      case 'agency':
        var win = Ext.widget('agencyselector', {
          listeners: {
            scope: this,
            selected: function(win, records) {
              var config = this.agencyFilterConfig(records[0]),
                  store = this.getStore('SearchResults');

              this.showFilterPbar();
              Ext.defer(store.addAssociatedIdFilter, 100, store, [config]);
            }
          }
        });
        win.show();
        break;
      case 'source':
        var win = Ext.widget('agencyselector', {
          listeners: {
            scope: this,
            selected: function(win, records) {
              var config = this.sourceFilterConfig(records[0]),
                  store = this.getStore('SearchResults');

              this.showFilterPbar();
              Ext.defer(store.addAssociatedIdFilter, 100, store, [config]);
            }
          }
        });
        win.show();
        break;
      case 'region':
        this.showFilterPbar();
        var config = this.stringFilterConfig(field, value, "Region: " + value);
        Ext.defer(store.addStringFilter, 100, store, [config]);
        break;
      case 'contact':
        var win = Ext.widget('personselector', {
          listeners: {
            scope: this,
            selected: function(win, records) {
              var config = this.contactFilterConfig(records[0]),
                  store = this.getStore('SearchResults');

              this.showFilterPbar();
              Ext.defer(store.addAssociatedIdFilter, 100, store, [config]);
            }
          }
        });
        win.show();
        break;
      case 'year':
        Ext.Msg.prompt('Filter by year', 'Please enter a year:', function(btn, year) {
          if(btn == 'ok') {
            this.showFilterPbar();
            config = this.yearFilterConfig(year);
            Ext.defer(store.addYearFilter, 100, store, [config]);
          }
        }, this);
        break;
    }
  },

  showFilterPbar: function(msg) {
    return Ext.Msg.show({
      title: 'Please wait...',
      msg: msg || 'Filtering records',
      minWidth: 300,
      wait: true,
      modal: false
    });
  },

  contactFilterConfig: function(item) {
    return {
      name: 'contact',
      description: 'Contact: "' + item.get('full_name') + '"',
      fields: ['primary_contact_id', 'person_ids'],
      value: item.get('id'),
      append: true
    }
  },

  sourceFilterConfig: function(agency) {
    return {
      name: 'source',
      description: 'Source: "' + agency.get('name') + ' (' + agency.get('acronym') + ')' + '"',
      fields: ['source_agency_id'],
      value: agency.get('id')
    }
  },

  agencyFilterConfig: function(agency) {
    return {
      name: 'agency',
      description: 'Agency: "' + agency.get('name') + ' (' + agency.get('acronym') + ')' + '"',
      fields: ['agency_ids', 'source_agency_id'],
      value: agency.get('id'),
      append: true
    }
  },

  yearFilterConfig: function(value) {
    return { year: value };
  },

  stringFilterConfig: function(field, value, description) {
    if(!description) {
      description = field.capitalize() + ' = "' + value + '"';
    }
    return {
      name: field,
      description: description,
      string: value,
      fields: [field]
    };
  },

  show: function() {
    this.getStore('SearchResults').load();
    this.getStore('SearchResults').clearCachedFilter('name', 'hideall');

    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  },

  showAllRecords: function() {
    this.getStore('SearchResults').clearAllCachedFilters();
  },

  onAoiAdd: function(map, feature, e) {
    this.showFilterPbar();
    var store = this.getStore('SearchResults');
    map.fit(feature.geometry.getBounds());
    Ext.defer(store.aoiFilter, 100, store, [feature.geometry, map]);
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

  onFilterClick: function(view, record, node, index, e, opts) {
    var target = Ext.fly(e.target);
    if (target && target.getAttribute('action') == 'remove') {
      this.getStore('SearchResults').clearCachedFilter('id', target.getAttribute('id'));
    }
  },

  onFeatureClick: function(map, feature) {
    var store = this.getStore('SearchResults');
    var index = store.find('id', feature.attributes.id);
    var r = store.getAt(index);
//    this.openWindow(r);
  },

  /* Old cluster click handler */
  onClusterClick: function(map, feature) {
    this.showFilterPbar('Selecting records that include this location');

    var ids = {};
    Ext.each(feature.cluster, function(item) {
      ids[item.attributes.id] = item.attributes.title;
    });

    var fn = function(record, id) {
      var me = this;
      var foundItems = [];
      var skippedItems = [];

      return me[record.get('id')] ? true : false;
    };

    var filter = new Ext.util.Filter({
      filterFn: Ext.bind(fn, ids)
    });

    //Delay this to allow some time for the browser to render the progress bar
    Ext.defer(
      this.getStore('SearchResults').cachedFilterBy, 100, this.getStore('SearchResults'),
      ['geographic', "Selected map feature", filter]
    );
  }
});