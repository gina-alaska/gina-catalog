Ext.define('App.controller.Search', {
  extend: 'Ext.app.Controller',

  refs: [{
    ref: 'mapPanel',
    selector: 'catalog_map'
  }, {
    ref: 'textsearch',
    selector: 'catalog_toolbar textfield[name="q"]'
  }, {
    ref: 'applyButton',
    selector: 'catalog_sidebar button[action="search"]'
  }],

  stores: [ 'Catalog', 'Filters' ],

  init: function() {
    this.control({
      'catalog_toolbar textfield[name="q"]': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      'catalog_toolbar button[action="export"]': {
        click: function() { this.doSearch('pdf'); }
      },
      'catalog_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'catalog_toolbar button[action="clear_filters"]': {
        click: this.clearFilters
      },
      'catalog_toolbar button[action="clear_text"]': {
        click: function() { this.clearSearchParam('q'); }
      },
      'catalog_toolbar menuitem[action="filter"]': {
        click: this.doFilter
      },
      
      /* Search filter events */
      'catalog_sidebar filterlist': {
        itemclick: this.onFilterClick
      },
      'catalog_sidebar button[action="search"]': {
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
    this.getStore('Filters').on('add', this.enableApplyButton, this);
  },
  
  enableApplyButton: function(){
    this.getApplyButton().enable();
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

  doSearch: function(format) {
    var searchField = Ext.ComponentQuery.query('catalog_toolbar textfield[name="q"]')[0];
    this.replaceSearchParam('q', searchField.getValue(), 'Text: ' +  searchField.getValue());
    
    var rawParams = this.getSearchParams();
    var params = {};
    for(var name in rawParams) {
      if(rawParams[name]) {
        var n = "search[" + name +"]";
        if(Ext.isArray(rawParams[name])) {
          n += "[]";
        }
        params[n] = rawParams[name];        
      }
    }

    if(format && format == 'pdf') {
      window.open('/data.pdf?'+Ext.Object.toQueryString(params));
    } else {
      this.getStore('Catalog').load({
        params: Ext.Object.toQueryString(params)
      });      
    }
    
    this.getApplyButton().disable();
  },

  getSearchParams: function(id) {
    var filters = this.getStore('Filters');
  
    params={};
    filters.each(function(f) {
      if(params[f.get('field')]) {
        //Do we have an array of values?
        if(Ext.isArray(params[f.get('field')])) {
          //Yes, Push new value onto the array
          params[f.get('field')].push(f.get('value'));
        } else {
          //No, make it an array with the two values
          params[f.get('field')] = [params[f.field], f.get('value')];
        }
      } else {
        //Put the value into the params
        params[f.get('field')] = f.get('value');
      }
    }, this);

    return params;
  },
  
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
    /* Don't use removeAll, it doesn't fire the remove event */
    this.getStore('Filters').each(function(item) {
      this.getStore('Filters').remove(item);
    }, this);
    // this.doSearch();
  },
  
  doFilter: function(item) {
    var win;
    
    switch(item.filterType) {
      case 'single':
        // this.clearSearchParams( item.field );
        this.replaceSearchParam(item.field, item.value, item.description);
        /* now handled by the apply button, unless immediateSearch is true */
        if(item.immediateSearch === true) {
          this.doSearch();
        }
        break;
      case 'multiple':
        this.addSearchParam(item.field, item.value, item.description);
        /* now handled by the apply button, unless immediateSearch is true */
        if(item.immediateSearch === true) {
          this.doSearch();
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