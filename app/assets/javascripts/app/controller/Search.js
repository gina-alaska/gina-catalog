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
      'catalog_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'catalog_toolbar menuitem[action="filter"]': {
        click: this.doFilter
      }
    });

    this.activeSearchId = 0;
    this.searchParams = new Ext.util.MixedCollection();
  },

  doSearch: function() {
    var searchField = Ext.ComponentQuery.query('catalog_toolbar textfield[name="q"]')[0];
    this.updateSearchParams('q', searchField.getValue(), 'Text: ' +  searchField.getValue());

    var rawParams = this.getSearchParams();
    var params = {};
    for(var name in rawParams) {
      var n = "search[" + name +"]";
      if(Ext.isArray(rawParams[name])) {
        n += "[]";
      }
      params[n] = rawParams[name].value;
    }

    this.getStore('Catalog').load({
      params: Ext.Object.toQueryString(params)
    });
  },

  getSearchParams: function(id) {
    if(!id) {
      id = this.activeSearchId;
    }
    var params = this.searchParams.get(id);
    if(!params) {
      params = {}
    }
    console.log(params);
    return params;
  },

  updateSearchParams: function(key, value, desc) {
    var params = this.getSearchParams();
    if(value == "") {
        delete params[key]
    }
    else if(!params[key] || params[key].value != value) {
      params[key] = { value: value, description: desc };
      this.activeSearchId += 1;
      this.searchParams.add(this.activeSearchId, params);
    }
  },
  

  doFilter: function(item) {
    switch(item.query) {
      case 'string':
        console.log("STRING!");
        this.updateSearchParams(item.field,item.value,item.description);
        this.doSearch();
        break;
      case 'agencyselector':
        console.log(item);
        var win = Ext.create("App.view.agency.selector",{
          scope: this,
          field: item.field,
          description: item.description,
          callback: this.doFilter
        });
        win.show();
        break;
      case 'contactselector':
        var win = Ext.create("App.view.person.selector", {
          scope: this,
          field: item.field,
          description: item.description,
          callback: this.doFilter
        });
        win.show();
        //this.updateSearchParams(item.field, [1,2,3]);
        break;
      default:
        console.log("Default");
        break;
    }
  } 
});