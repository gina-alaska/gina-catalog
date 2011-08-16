Ext.define('Ext.gina.filter.Manager', {
  filters: new Ext.util.MixedCollection(true),

  config: {
    store: null
  },

  statics: {
    counter: 0,
    getNextCounter: function() {
      this.counter += 1;
      return this.counter;
    }
  },

  constructor: function(config) {
    this.initConfig(config);
    this.callParent(arguments);
  },

  add: function(name, desc, func, scope) {
    var filter = new Ext.util.Filter({ id: name, filterFn: Ext.bind(func, scope) });
    
    this.filters.add({
      "id": name + Ext.gina.filter.Manager.getNextCounter(),
      "desc": desc,
      "filter": filter
    });

    var activeFilters = this.filters.collect('filter');
    console.log(activeFilters);
    //this.store.clearFilter();
    this.store.filter(activeFilters);
    console.log(this.store.data);
  },

  clearFilter: function() {
    this.filters.clear();
    this.store.clearFilter();
  },

  filterBy: function(func, scope) {
    this.add('filterBy', '', func, scope);
  },

  filter: function() {

  },

  filterByString: function(string, filterName) {
    this.add(filterName || 'string', 'Searching for ' + string, Ext.bind(this.matchAllString, this, [string], true));
  },

  matchAllString: function(record, string){
    if(string.length < 1){ return; }

    var found = false;
    var search = new RegExp();

    //Remove multiple spaces
    var search_items = string.replace(/\s+/,' ').split(' ').uniq();

    for (var ii=0; ii < search_items.length; ii++) {
      found = false;

      search.compile(search_items[ii], 'i');
      for (field in record.data) {
        found = found || search.test(record.get(field));
      }

      if(found === false) { return false; }
    }

    return found;
  }
})