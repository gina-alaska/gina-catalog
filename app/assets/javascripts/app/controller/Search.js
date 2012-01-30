Ext.define('App.controller.Search', {
  extend: 'Ext.app.Controller',

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
      'catalog_toolbar menuitem[action="filter"]': {
        click: this.doFilter
      },
      
      /* Search filter events */
      'catalog_sidebar filterlist': {
        itemclick: this.onFilterClick
      },
      
      'catalog_map': {
        clusterclick: this.onClusterClick,
        aoiadded: this.onAOIAdd
      }
    });

    this.activeSearchId = 0;
    this.searchParams = new Ext.util.MixedCollection();
  },
  
  onAOIAdd: function(panel, feature){
    var geom = feature.geometry;
    geom.transform(panel.getMap().getProjectionObject(), panel.getMap().displayProjection);
    
    this.doFilter({
      filterType: 'single',
      field: 'bbox',
      value: geom.toString(),
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
      description: 'Selected Feature'
    });
  },
  
  onFilterClick: function(view, record, node, index, e, opts) {
    var target = Ext.fly(e.target);
    if (target && target.getAttribute('action') == 'remove') {
      this.clearSearchParams(record.get('field'), record.get('value'));
      this.doSearch();
    }
  },

  doSearch: function(format) {
    var searchField = Ext.ComponentQuery.query('catalog_toolbar textfield[name="q"]')[0];
    this.clearSearchParams('q');
    this.updateSearchParams('q', searchField.getValue(), 'Text: ' +  searchField.getValue());
    
    var rawParams = this.getSearchParams();
    var params = {};
    for(var name in rawParams) {
      var n = "search[" + name +"]";
      if(Ext.isArray(rawParams[name])) {
        n += "[]";
      }
      params[n] = rawParams[name];
    }

    if(format && format == 'pdf') {
      window.open('/data.pdf?'+Ext.Object.toQueryString(params));
    } else {
      this.getStore('Catalog').load({
        params: Ext.Object.toQueryString(params)
      });      
    }
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
  
  clearSearchParams: function(field, value) {
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

  updateSearchParams: function(field, value, desc) {
    var filters = this.getStore('Filters');
    
    // Don't add blank values
    if(value === "") { return false; }
    
    var index = this.findSearchParam(field, value);
    if(index < 0) {
      // Value doesn't exist in the filters yet
      filters.add({ field: field, value: value, desc: desc });
    }
  },
  

  doFilter: function(item) {
    var win;
    
    switch(item.filterType) {
      case 'single':
        this.clearSearchParams( item.field );
        this.updateSearchParams(item.field, item.value, item.description);
        this.doSearch();
        break;
      case 'multiple':
        this.updateSearchParams(item.field, item.value, item.description);
        this.doSearch();
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
      default:
        console.log("Default");
        break;
    }
  } 
});