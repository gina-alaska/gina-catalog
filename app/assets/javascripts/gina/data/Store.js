Ext.define('Ext.gina.data.Store', {
  extend: 'Ext.data.Store',

  constructor: function() {
    this.nextFilterId = 0;
    this.filterStore = Ext.create('Ext.data.Store', {
      fields: ['name', 'desc', 'filter']
    });
    
    this.addEvents('clearedfilters', 'removefilter');

    this.callParent(arguments);
  },

  getNextFilterId: function() {
    this.nextFilterId += 1;
    return this.nextFilterId;
  },

  filterBy: function(fn, scope) {
    var filter = Ext.create('Ext.util.Filter', {
      filterFn: Ext.bind(fn, scope)
    });
    
    this.cachedFilterBy('filterBy', 'Filtered by function', filter)
  },

  clearCachedFilter: function(field, value) {
    var index = this.filterStore.find(field, value);
    var r = this.filterStore.getAt(index);
    if(r) { var name = r.get('name'); }
    
    this.filterStore.removeAt(index);

    this.doCachedFilter();
    this.fireEvent('removefilter', this, name);
  },

  clearAllCachedFilters: function() {
    this.filterStore.removeAll();
    this.doCachedFilter();
    this.fireEvent('removefilter', this, 'all');
    this.fireEvent('clearedfilters', this);
  },

  cachedFilterBy: function(name, desc, filter, append) {
    if(filter !== false) {
      var index = this.filterStore.find('name', name);
      if(index >= 0 && !append) {
        var r = this.filterStore.getAt(index);
        r.set('desc', desc);
        r.set('filter', filter);
      } else {
        this.filterStore.add({ id: this.getNextFilterId(), "name": name, "desc": desc, "filter": filter })
      }
    } else {
      this.clearCachedFilter('name', name);
    }
    this.doCachedFilter();

    return this;
  },

  doCachedFilter: function() {
    this.clearFilter();
    this.filter(this.cachedFilters());
  },

  cachedFilters: function() {
    var filters = [];
    this.filterStore.each(function(f) {
      filters.push(f.get('filter'));
    });
    return filters;
//    return this.filterCache.collect('filter')
  },

  addHideAllFilter: function() {
    this.addFilterFn('hideall', 'Hide them all', function() { return false; });
  },

  addAssociatedIdFilter: function(config) {
    var fn = Ext.bind(function(record, id) {
      var found = false;
      
      if(config.fields == 'all') {
        for (field in record.data) {
          if(Ext.isArray(record.get(field)) && record.get(field).indexOf(config.value) >= 0){
            return true;
          } else if(record.get(field) == config.value) {
            return true;
          }
        }
      } else {
        found = Ext.Array.some(config.fields, function(field) {
          if(Ext.isArray(record.get(field)) && record.get(field).indexOf(config.value) >= 0) {
            return true;
          } else if(record.get(field) == config.value) {
            return true;
          }
        }, this);
      }

      return found;
    }, this);

    this.addFilterFn(config.name, config.description, fn, config.append);
  },

  addYearFilter: function(config) {
    var fn = Ext.bind(function(record, id) {
      var found = Ext.isNumber(record.get('start_date_year')) || Ext.isNumber(record.get('end_date_year'));
      if(Ext.isNumber(record.get('start_date_year'))) {
        found = found && (record.get('start_date_year') <= config.year)
      }
      if(Ext.isNumber(record.get('end_date_year'))) {
        found = found && (record.get('end_date_year') >= config.year)
      }
      return found;
    }, this);
    
    this.addFilterFn('year', 'Year: ' + config.year, fn);
  },

  addStringFilter: function(filterConfig) {
    Ext.applyIf(filterConfig, {
      name: 'string',
      description: 'Text search: "' + filterConfig.string + '"',
      fields: 'all'
    });

    if(filterConfig.string === false || filterConfig.string === undefined || filterConfig.string.length < 1){
      return this.clearCachedFilter('name', filterConfig.name);
    }

    var field;
    var found = null;
    var search = new RegExp();

    //Remove multiple spaces
    var search_items = filterConfig.string.replace(/\s+/,' ').split(' ').uniq();

    var fn = Ext.bind(function(record, id){
      found = false;

      for (var ii=0; ii < search_items.length; ii++) {
        found = false;

        search.compile(search_items[ii], 'i');
        if(filterConfig.fields == 'all') {
          for (field in record.data) {
            found = found || search.test(record.get(field));
          }
        } else {
          for (field in filterConfig.fields) {
            found = found || search.test(record.get(filterConfig.fields[field]));
          }
        }

        if(found === false) { return false; }
      }
      return found;
    }, this);

    this.addFilterFn(filterConfig.name, filterConfig.description, fn);
  },

  addFilterFn: function(name, desc, fn, append) {
    var filter = Ext.create('Ext.util.Filter', { filterFn: fn });
    this.cachedFilterBy(name, desc, filter, append);
  },

  filterByString: function(string, fields) {
    this.addStringFilter({ string: string, fields: fields });
  }
});