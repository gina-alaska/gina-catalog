Ext.define('App.store.Filters', {
  extend: 'Ext.data.Store',

  storeId: 'Filters',
  model: 'App.model.Filter',
  autoLoad: false,
  listeners: {
//    exception: Ext.ux.StoreHandlers.failure
  },

  buildFilterRequest: function() {
    var params = {};
    var filters = [];
   
    this.each(function(f) {
      if(params[f.get('field')]) {
        //Do we have an array of values?
        if(Ext.isArray(params[f.get('field')])) {
          //Yes, Push new value onto the array
          params[f.get('field')].push(f.get('value'));
        } else {
          //No, make it an array with the two values
          params[f.get('field')] = [params[f.get('field')], f.get('value')];
        }
      } else {
        //Put the value into the params
        params[f.get('field')] = f.get('value');
      }
    }, this);

    for(var name in params) {
      if(params[name]) {
        filters.push({
          property: name,
          value: params[name]
        });
      }
    }

    return filters; 
  }
});