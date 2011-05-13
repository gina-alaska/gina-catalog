Ext.ns('Ext.ux.StoreHandlers');

Ext.ux.StoreHandlers = {
  failure: function(proxy, type, action, request, response, error) {
    var json = {};
    if(response.getResponseHeader('Content-Type').match(/json/)) {
      json = Ext.decode(response.responseText);
    }
    console.log(arguments);
    if(response.status == 403) {
      //
      if (options.listeners && options.listeners.forbidden) {
        var status = options.listeners.forbidden.call(options.listeners.scope || this, response, options, json)
      }
      if(status !== false && json.flash) {
        Ext.ux.Notify.show('Error', json.flash);
      }
    } else {
      Ext.ux.Notify.show('Error', json.flash || 'An unknown error occurred during the request');
    }
  }
}