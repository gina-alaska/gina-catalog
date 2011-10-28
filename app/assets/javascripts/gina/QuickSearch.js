Ext.define('Ext.gina.QuickSearch', {
  extend: 'Ext.container.ButtonGroup',
  alias: 'widget.quicksearch',

  cls: 'quicksearch',

  config: {
    store: null,
    maskEl: false,
    matchAll: true,
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

    this.items = [{
      itemId: 'q',
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
      scope: this,
      scale: 'medium',
      scope: this,
      handler: this.clearHandler
    }, {
      iconCls: 'search-icon',
      scope: this,
      scale: 'medium',
      scope: this,
      handler: this.searchHandler
    }];

    this.callParent();
  },

  searchHandler: function(item) {
    var parent = item.ownerCt;
    var string = parent.getComponent('q').getValue();

    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).mask('Please wait...', 'x-mask-loading');
    }
    Ext.defer(this.search, 100, this, [string]);
  },

  clearHandler: function(item) {
    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).mask('Please wait...', 'x-mask-loading');
    }
    Ext.defer(this.clear, 100, this, [item])
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

    //Remove multiple spaces
    var search_items = search_string.replace(/\s+/,' ').split(' ').uniq();

    //Always clear the last filter before doing a new filter
    this.getStore().filterByString(search_string);

    if(this.getMaskEl()) {
      Ext.get(this.getMaskEl()).unmask();
    }
  }
})