Ext.define('App.controller.Search', {
  extend: 'Ext.app.Controller',

  stores: [ 'Catalog' ],

  init: function() {
    this.control({
     'viewport #catalog button[action="search"]': {
        click: this.doSearch
      }
    });

    this.activeSearchId = 0;
    this.searchParams = new Ext.util.MixedCollection();
  },


  doSearch: function(btn) {
    this.updateSearchParams();

    this.getStore('Catalog').load({params: this.getSearchParams() });
  },

  getSearchParams: function(id) {
    if(!id) {
      id = this.activeSearchId;
    }
    var params = this.searchParams.get(id);
    if(!params) {
      params = {}
    }
    return params;
  },

  updateSearchParams: function() {
    var searchField = Ext.ComponentQuery.query('catalog_toolbar textfield[name="q"]')[0];

    var params = this.getSearchParams();
    params.q = searchField.getValue();
    this.activeSearchId += 1;
    this.searchParams.add(this.activeSearchId, params);

  }
});