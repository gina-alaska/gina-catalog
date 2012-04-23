Ext.define('App.controller.Search', {
  extend: 'Ext.app.Controller',

  refs: [{
    ref: 'mapPanel',
    selector: 'catalog_map'
  }, {
    ref: 'textsearch',
    selector: 'catalog_sidebar textfield[name="q"]'
  }, {
    ref: 'applyButton',
    selector: 'catalog_sidebar button[action="apply"]'
  }, {
    ref: 'sidebar',
    selector: 'catalog_sidebar'
  }, {
    ref: 'filters',
    selector: 'catalog_sidebar #filters'
  }, {
    ref: 'results',
    selector: 'catalog_sidebar #results'
  }],

  stores: [ 'Catalog', 'Filters' ],

  init: function() {
    this.control({
      'catalog_text_search button[action="clear_text"]': {
        click: function() { this.clearSearchParam('q'); }
      },
      'catalog_text_search button[action="search"]': {
        click: this.doSearch
      },
      'catalog_other_buttons button[action="export"]': {
        click: function() { this.doSearch({ format: 'pdf' }); }
      },
      'catalog_other_buttons menuitem[action="filter"]': {
        click: this.doFilter
      },
      'catalog_search_buttons button[action="filter"]': {
        click: this.doFilter
      },
      'catalog_search_buttons menuitem[action="filter"]': {
        click: this.doFilter
      },
      
      
      /* Search filter events */
      'catalog_sidebar textfield[name="q"]': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      'catalog_sidebar button[action="clear_filters"]': {
        click: this.clearFilters
      },
      'catalog_sidebar filterlist': {
        itemclick: this.onFilterClick
      },
      'catalog_sidebar button[action="apply"]': {
        click: this.doSearch
      },
      
      'catalog_map': {
        clusterclick: this.onClusterClick,
        aoiadded: this.onAOIAdd
      }
    });

    this.activeSearchId = 0;
    this.searchParams = new Ext.util.MixedCollection();
    
    this.getStore('Filters').on('remove', this.onFilterRemoved, this);
    // this.getStore('Filters').on('add', this.enableApplyButton, this);
  },
  
  enableApplyButton: function(){
    this.showFilters();
    
    // this.getApplyButton().enable();
    this.getApplyButton().addCls('notice');
    // custom: highlight foreground text to blue for 2 seconds
    this.getApplyButton().getEl().highlight('00ff00');
  },
  disableApplyButton: function(){
    this.getApplyButton().removeCls('notice');
    // this.getApplyButton().disable();
  },
  
  onAOIAdd: function(panel, feature){
    var mp = this.getMapPanel();
    
    var geom = feature.geometry;
    geom.transform(mp.getMap().getProjectionObject(),mp.getMap().displayProjection);
    
    mp.control('aoi').deactivate();
    
    this.doFilter({
      filterType: 'single',
      field: 'bbox',
      value: geom.toString(),
      immediateSearch: true,
      description: 'AOI Selection'
    });
  },
  
  onClusterClick: function(map, cluster, opts) {
    var ids = [];
    Ext.each(cluster.cluster, function(feature) {
      ids.push(feature.attributes.id);
    }, this);    
    
    this.doFilter({
      filterType: 'single',
      field: 'ids', 
      value: ids, 
      immediateSearch: true,
      description: 'Selected Feature'
    });
  },
  
  onFilterClick: function(view, record, node, index, e, opts) {
    var target = Ext.fly(e.target);
    if (target && target.getAttribute('action') == 'remove') {
      this.clearSearchParam(record.get('field'), record.get('value'));
      // this.doSearch();
    }
  },
  
  doSearch: function(opts){
    if(!opts) { opts = {}; }
    this.showResults();
    
    var searchField = this.getTextsearch();
    this.replaceSearchParam('q', searchField.getValue(), 'Text: ' +  searchField.getValue());
    if(opts.format == 'pdf') {
      var url = this.getStore('Catalog').getProxy().url;
      window.open('/search.pdf?limit=200&filter=' + Ext.encode(this.getStore('Filters').buildFilterRequest()));
    } else {
      this.getStore('Catalog').filters.clear();
      this.getStore('Catalog').filter(this.getStore('Filters').buildFilterRequest());
      this.disableApplyButton();
    }
  },

  // getSearchParams: function(id) {
  //   var filters = this.getStore('Filters');
    
  //   // params={};
  //   // filters.each(function(f) {
  //   //   if(params[f.get('field')]) {
  //   //     //Do we have an array of values?
  //   //     if(Ext.isArray(params[f.get('field')])) {
  //   //       //Yes, Push new value onto the array
  //   //       params[f.get('field')].push(f.get('value'));
  //   //     } else {
  //   //       //No, make it an array with the two values
  //   //       params[f.get('field')] = [params[f.get('field')], f.get('value')];
  //   //     }
  //   //   } else {
  //   //     //Put the value into the params
  //   //     params[f.get('field')] = f.get('value');
  //   //   }
  //   // }, this);

  //   return params;
  // },
  
  clearSearchParam: function(field, value) {
    var filters = this.getStore('Filters');
    var index = this.findSearchParam(field, value);
    if(index >= 0) { filters.removeAt(index); }
  },
  
  findSearchParam: function(field, value) {
    var filters = this.getStore('Filters');
    
    return filters.findBy(function(item) {
      return item.get('field') == field && (value === undefined || item.get('value') == value);
    }, this);
  },

  addSearchParam: function(field, value, desc) {
    var filters = this.getStore('Filters');
    
    // Don't add blank values
    if(value === "") { return false; }
    
    var index = this.findSearchParam(field, value);
    if(index < 0) {
      // Value doesn't exist in the filters yet
      filters.add({ field: field, value: value, desc: desc });
    }
  },
  
  replaceSearchParam: function(field, value, desc) {
    var filters = this.getStore('Filters');
    
    // Don't add blank values
    if(value === "") { return false; }
    var index = this.findSearchParam(field);
    var data = { field: field, value: value, desc: desc };
    if(index < 0) {
      // Value doesn't exist in the filters yet
      filters.add(data);
    } else {
      var r = filters.getAt(index);
      r.data = data;
      r.commit();
    }
  },
  
  onFilterRemoved: function(store, record, index) {
    switch(record.get('field')) {
      case 'q':
        this.getTextsearch().setValue('');
        break;
      case 'bbox':
        this.getMapPanel().layer('aoi').removeAllFeatures();
        break;
    }
    this.enableApplyButton();
  },

  clearFilters: function() {
    this.getStore('Filters').removeAll();
    this.getTextsearch().setValue('');
    this.getMapPanel().layer('aoi').removeAllFeatures();
    this.enableApplyButton();
  },
  
  showFilters: function() {
    this.getSidebar().setActiveTab(this.getFilters());    
  },
  
  showResults: function() {
    this.getSidebar().setActiveTab(this.getResults());
  },
  
  doFilter: function(item) {
    var win;
    switch(item.filterType) {
      case 'sort':
        this.replaceSearchParam(item.field, item.value, item.description);
        var sort = item.value.split('-'),
            field = sort[0],
            dir = sort[1];

        this.getStore('Catalog').sort(field, dir);        
        break;
      case 'single':
        this.replaceSearchParam(item.field, item.value, item.description);
        /* now handled by the apply button, unless immediateSearch is true */
        if(item.immediateSearch === true) {
          this.doSearch(true);
        } else {
          this.enableApplyButton();
        }
        break;
      case 'multiple':
        this.addSearchParam(item.field, item.value, item.description);
        /* now handled by the apply button, unless immediateSearch is true */
        if(item.immediateSearch === true) {
          this.doSearch(true);
        } else {
          this.enableApplyButton();
        }
        break;
      case 'sourceselector':
        win = Ext.create("App.view.agency.selector",{
          scope: this,
          field: item.field,
          description: item.description,
          filterType: 'single',
          callback: this.doFilter
        });
        win.show();
        break;
      case 'isothemeselector':
        win = Ext.create("App.view.isotheme.selector",{
          scope: this,
          field: item.field,
          description: item.description,
          filterType: 'multiple',
          callback: this.doFilter
        });
        win.show();
        break;        
      case 'agencyselector':
        win = Ext.create("App.view.agency.selector",{
          scope: this,
          field: item.field,
          description: item.description,
          filterType: "multiple",
          callback: this.doFilter
        });
        win.show();
        break;
      case 'contactselector':
        win = Ext.create("App.view.person.selector", {
          scope: this,
          field: item.field,
          description: item.description,
          filterType: 'single',
          callback: this.doFilter
        });
        win.show();
        break;
      case 'dateselector':
        win = Ext.create("App.view.filter.date", {
          width: 300,
          height: 100,
          scope: this,
          field: item.field,
          description: item.description,
          filterType: 'single',
          callback: this.doFilter
        });
        win.show();
        break;
    }
  } 
});