App.views.add('catalog-mappy-framework', function() {
  var defaultSearch = new Ext.ux.DefaultText({
    text: 'Enter your search here...'
  });

  var StoreFiltering = function(config) {
    Ext.apply(this, config, {
      matchAll: true,
      fields: 'all'
    });

    this.handler = function(item) {
      var tbar = item.ownerCt;
      var string = tbar.get('q').getValue();

      Ext.get(this.maskEl).mask('Please wait...', 'x-mask-loading');
      this.search.defer(200, this, [string])
    }

    this.clear = function(item) {
      if(item) {
        item.ownerCt.get('q').setValue('');
        item.ownerCt.get('q').focus().blur();
      }
      this.store.clearFilter();

      if(this.maskEl) {
        Ext.get(this.maskEl).unmask();
      }
    };

    this.search = function(search_string) {
      if(search_string.length < 1){
        this.clear();
        return;
      }

      var v;
      var o = {start: 0};
      var field;
      var visible = true;
      var found = null;
      var search = new RegExp();

      //Remove multiple spaces
      var search_items = search_string.replace(/\s+/,' ').split(' ').uniq();

      //Always clear the last filter before doing a new filter
      this.store.filterBy(function(record, id){
        found = false;

        for (var ii=0; ii < search_items.length; ii++) {
          if(this.matchAll === true) { found = false; }

          search.compile(search_items[ii], 'i');

          if(this.fields == 'all') {
            for (field in record.data) {
              found = found || search.test(record.get(field));
            }
          } else {
            for (field in this.fields) {
              found = found || search.test(record.get(this.fields[field]));
            }
          }

          if(this.matchAll === true && found === false) { return false; }
        }
        return found;
      }, this);

      if(this.maskEl) {
        Ext.get(this.maskEl).unmask();
      }
    };
  }
  var filter = new StoreFiltering({
    store: App.store('search_results'),
    maskEl: 'search_results'
  });

  return {
    layout: 'border',
    tbar: {
      xtype: 'toolbar',
      cls: 'search',
      items: [ {
        xtype: 'buttongroup',
        items: [{
          itemId: 'q',
          plugins: [defaultSearch],
          xtype: 'textfield',
          store: App.store('search_results'),
          listeners: {
            scope: filter,
            specialkey: function(field, e) {
              if(e.getKey() == e.ENTER) {
                this.handler(field);
              }
            }
          },
          width: 400
        },{
          icon: '/images/icons/medium/x.png',
          scope: this,
          scale: 'medium',
          scope: filter,
          handler: filter.clear
        }, {
          icon: '/images/icons/medium/search.png',
          scope: this,
          scale: 'medium',
          scope: filter,
          handler: filter.handler
        }]
      }, '->', {
        icon: '/images/icons/medium/computer.png',
        scale: 'large',
        text: '<b>Advanced Search</b>'
      }, {
        icon: '/images/icons/medium/print.png',
        scale: 'large',
        text: '<b>Export Search Results</b>'
      }]
    },
    defaults: { margins: '5 0 0 0' },
    items: [
      App.view('catalog-map', [{
        region: 'center'
      }]),
      App.view('catalog-search-results', [{
        id: 'search_results',
        itemId: 'list',
        region: 'west',
        split: true,
        width: 350
      }])
    ]
  }
});