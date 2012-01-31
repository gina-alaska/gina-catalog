Ext.define('Ext.gina.QuickSearch', {
  extend: 'Ext.container.ButtonGroup',
  alias: 'widget.quicksearch',

  cls: 'quicksearch',

  config: {
    store: null,
    maskEl: false,
    matchAll: true,
    width: 500,
    fields: 'all'
  },
  
  constructor: function(config) {
    this.initConfig(config);
    this.callParent();
  },

  initComponent: function() {
    var defaultSearch = Ext.create('Ext.gina.DefaultText', {
      text: 'Enter your search here...'
    });
    
    console.log(this, this.getStore());

    this.items = [{
      name: 'q',
      plugins: [defaultSearch],
      xtype: 'textfield',
      store: this.getStore(),
      listeners: {
        scope: this,
        specialkey: function(field, e) {
          if(e.getKey() == e.ENTER) {
            this.searchHandler(field);
          }
        }
      },
      width: (this.width ? (this.width - 70) : 500)
    },{
      iconCls: 'cancel-icon',
      scale: 'medium',
      scope: this,
      handler: this.clearHandler
    }, {
      iconCls: 'search-icon',
      scale: 'medium',
      scope: this,
      handler: this.searchHandler
    }];

    this.callParent();
  },

  searchHandler: function(item) {
    var win = item.up('window');
    var string = win.down('textfield[name="q"]').getValue();
    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).mask('Please wait...', 'x-mask-loading');
    }
    Ext.defer(this.stringSearch, 100, this, [string]);
  },

  clearHandler: function(item) {
    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).mask('Please wait...', 'x-mask-loading');
    }
    Ext.defer(this.clear, 100, this, [item]);
  },

  clear: function(skipFiltering) {
    if(this.down('textfield')) {
      this.down('textfield').setValue('');
      this.down('textfield').focus().blur();
    }

    /** Quick hack for events **/
    if(skipFiltering !== true) {
      this.suspendEvents();
      this.getStore().filterByString('');
      this.resumeEvents();
    }

    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).unmask();
    }
  },
  
  stringSearch: function(value) {
    var fields = 'all';
    var found = null;
    var search = new RegExp();

    //Remove multiple spaces
    var search_items = value.replace(/\s+/,' ').split(' ').uniq();

    var fn = Ext.bind(function(record, id){
      var field;
      var found = false;

      for (var ii=0; ii < search_items.length; ii++) {
        found = false;

        search.compile(search_items[ii], 'i');
        if(fields == 'all') {
          for (field in record.data) {
            found = found || search.test(record.get(field));
          }
        } else {
          for (field in fields) {
            found = found || search.test(record.get(fields[field]));
          }
        }

        if(found === false) { return false; }
      }
      return found;
    }, this);

    this.getStore().filterBy(fn);
  },

  search: function(search_string) {
    if(search_string.length < 1){
      return this.clear();
    }

    var v;
    var o = {start: 0};
    var field;
    var visible = true;
    var found = null;
    var search = new RegExp();
    var fields = this.fields || 'all';

    //Remove multiple spaces
    var search_items = search_string.replace(/\s+/,' ').split(' ').uniq();

    //Always clear the last filter before doing a new filter
    //this.getStore().filterByString(search_string);
    this.getStore().filter("fulltext", search_string);

    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).unmask();
    }
  }
});