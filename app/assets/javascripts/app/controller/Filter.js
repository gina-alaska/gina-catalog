/**
 * @class App.controller.Filter
 * @extends Ext.controller.Controller
 * Filter Controller for Catalog
 */
Ext.define('App.controller.Filter', {
  extend: 'Ext.app.Controller', 
      
  stores: ['SearchResults', 'Filters'],
  models: ['SearchResult', 'Filter'],
  
  refs: [{
    ref: 'mapPanel',
    selector: 'viewport > #center #results-map'
  }],
      
  initComponent: function() {
    this.callParent(arguments);
  },
  
  init: function(){
    this.control({
      /* Sidebar events */
      'viewport > #center catalogsidebar': {
        "showall": this.showAllRecords,
        "drawaoi": function() { this.getMapPanel().aoiHandler(true); },
        "filter": this.filterHandler,
        "export": this.onExport
      },
      
      /* Search filter events */
      'viewport > #center catalogsidebar filterlist': {
        itemclick: this.onFilterClick
      },
      
      /* Map events */
      'viewport > #center #results-map': {
        clusterclick: this.onClusterClick,
        aoiadded: this.onAoiAdd,
      }      
    });
  },
  
  filterHandler: function(panel, type, field, value) {
    var config, win,
        store = this.getStore('SearchResults');

    switch(type) {
      case 'string':
        this.showFilterPbar();
        config = this.stringFilterConfig(field, value);
        Ext.defer(store.addStringFilter, 100, store, [config]);
        break;
      case 'agency':
        win = Ext.widget('agencyselector', {
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
        win = Ext.widget('agencyselector', {
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
        config = this.stringFilterConfig(field, value, "Region: " + value);
        Ext.defer(store.addStringFilter, 100, store, [config]);
        break;
      case 'contact':
        win = Ext.widget('personselector', {
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
      case 'date':
        fieldname = (field == 'start_date' ? 'Starting' : 'Ending');

        win = Ext.widget('filter_by_date', {
          width: 400,
          "field": field,
          "fieldName": fieldname,
          listeners: {
            scope: this,
            submit: function(win, field, fieldname, years) {
              this.showFilterPbar();
              var config = this.yearFilterConfig(field, fieldname, years);
              Ext.defer(store.addYearFilter, 100, store, [config]);
            }
          }
        });
        win.show();
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
    };
  },

  sourceFilterConfig: function(agency) {
    return {
      name: 'source',
      description: 'Source: "' + agency.get('name') + ' (' + agency.get('acronym') + ')' + '"',
      fields: ['source_agency_id'],
      value: agency.get('id')
    };
  },

  agencyFilterConfig: function(agency) {
    return {
      name: 'agency',
      description: 'Agency: "' + agency.get('name') + ' (' + agency.get('acronym') + ')' + '"',
      fields: ['agency_ids', 'source_agency_id'],
      value: agency.get('id'),
      append: true
    };
  },

  yearFilterConfig: function(field, fieldname, values) {
    var tpl = new Ext.Template('{0} {1} {2}');
    var desc = tpl.apply([fieldname, values.type, values.year]);
    
    return { 
      "field": field + '_year', 
      "type": values.type,
      "year": parseInt(values.year),
      "description": desc,
      "append": true
    };
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
  
  
  showAllRecords: function() {
    this.getStore('SearchResults').clearAllCachedFilters();
  },

  onAoiAdd: function(map, feature, e) {
    this.showFilterPbar();
    var store = this.getStore('SearchResults');
    map.fit(feature.geometry.getBounds());
    Ext.defer(store.aoiFilter, 100, store, [feature.geometry, map]);
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