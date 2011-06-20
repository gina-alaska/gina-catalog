Ext.ux.QuickSearchField = Ext.extend(Ext.form.TwinTriggerField, {
  initComponent : function(){
    if(typeof this.store == "string") {
      this.store = Ext.StoreMgr.get(this.store);
    }

    this.addEvents('before_filter', 'after_filter');

    Ext.ux.QuickSearchField.superclass.initComponent.call(this);

    this.on('specialkey', function(f, e){
        if(e.getKey() == e.ENTER){
            this.onTrigger2Click();
        }
    }, this);
  },

  validationEvent:false,
  validateOnBlur:false,
  trigger1Class:'x-form-clear-trigger',
  trigger2Class:'x-form-search-trigger',
  hideTrigger1:true,
  width:300,
  hasSearch : false,
  paramName : 'query',
  fields: 'all',
  matchAll: true,

  onTrigger1Click : function(){
    if(this.hasSearch){
      this.fireEvent('before_filter', this);
      this.clearSearch.defer(1000, this);
    }
  },

  clearSearch: function() {
    this.el.dom.value = '';
    var o = {start: 0};

    this.store.clearFilter();
    this.triggers[0].hide();
    this.hasSearch = false;
    this.fireEvent('after_filter', this);
  },

  doSearch: function() {
    var search_string = this.getRawValue();
    if(search_string.length < 1){
      this.onTrigger1Click();
      return;
    }
    var v;
    var o = {start: 0};
    var field;
    var visible = true;
    var found = null;
    var search = new RegExp();

    //Remove multiple spaces
    var search_items = search_string.replace(/\s+/,' ').split(' ');

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

    this.hasSearch = true;
    this.triggers[0].show();
    this.fireEvent('after_filter', this);
  },

  onTrigger2Click : function(){
    this.fireEvent('before_filter', this);
    this.doSearch.defer(1000, this);
  }
});
Ext.reg('quick_search_field', Ext.ux.QuickSearchField);