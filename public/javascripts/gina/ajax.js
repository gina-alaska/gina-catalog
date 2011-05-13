Ext.ux.Ajax = {
  formSubmit: function(request) {
    if(!request) { return false; }
    
    var form = Ext.getCmp(request.form),
        values = form.getForm().getValues(),
        id = values.id,
        params = {};

    if(id) {
      request.url += '/' + id;
    }

    Ext.applyIf(request, { method: (id ? 'PUT' : 'POST') });

    if (request.root) {
      for(var ii in values) {
        params[request.root + '[' + ii + ']'] = values[ii];
      }
      request.params = params;
    } else {
      request.params = values;
    }
    delete request.form;

    Ext.ux.Ajax.request(request);
  },

  request: function(config) {
    if(!config) { return false; }

    Ext.applyIf(config, {
      method: 'GET',
      success: Ext.ux.Ajax.success,
      failure: Ext.ux.Ajax.failure
    });

    if (config.mask) {
      if (config.mask === true) { config.mask = "Loading..."; }
      config.mask = new Ext.LoadMask(Ext.getBody(), { msg: config.mask });
      config.mask.show();
    }    

    Ext.Ajax.request(config);
  },

  success: function(response, options) {
    var json = {};
    
    if(response.getResponseHeader('Content-Type').match(/json/)) {
      json = Ext.decode(response.responseText);
    }

    if(options.mask) {
      options.mask.hide();
    }

    if(json.flash) {
      Ext.ux.Notify.show('Alert', json.flash);
    }

    if(json.redirect) {
      top.window.location = json.redirect;
    }

    if(options.listeners && options.listeners.success) {
      options.listeners.success.call(options.listeners.scope || this, response, options, json)
    }
  },

  failure: function(response, options) {
    var json = {};
    if(response.getResponseHeader('Content-Type').match(/json/)) {
      json = Ext.decode(response.responseText);
    }

    if(options.mask) {
      options.mask.hide();
    }

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

    if(options.listeners && options.listeners.failure) {
      options.listeners.failure.call(options.listeners.scope || this, response, options, json)
    }
  }
}
