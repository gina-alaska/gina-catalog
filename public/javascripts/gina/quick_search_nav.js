Ext.ux.QuickSearchNav = Ext.extend(Ext.form.TwinTriggerField, {
  initComponent : function(){
    if(typeof this.store == "string") {
      this.store = Ext.StoreMgr.get(this.store);
    }

    Ext.ux.QuickSearchNav.superclass.initComponent.call(this);

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

  onTrigger1Click : function(update_url){
    if(this.hasSearch){
      this.el.dom.value = '';
      var o = {start: 0};

      this.triggers[0].hide();
      this.hasSearch = false;
    }

    if(update_url || update_url === null || update_url === undefined) {
      var request = App.nav.getRequest();
      request.params.q = this.getRawValue();
      App.nav.quickLoad(request.controller, this.action, request.params);
    }
  },

  onTrigger2Click : function(update_url){
    var search_string = this.getRawValue();
    if(search_string.length < 1){
      this.onTrigger1Click();
      return;
    }
    
    if(update_url || update_url === null || update_url === undefined) {
      var request = App.nav.getRequest();
      request.params.q = this.getRawValue();
      request.action = this.action;
      App.nav.loadRequest(request);
    }

    this.hasSearch = true;
    this.triggers[0].show();
  }
});
Ext.reg('quick_search_nav', Ext.ux.QuickSearchNav);