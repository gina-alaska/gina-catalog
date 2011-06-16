Ext.ux.EventManager = function(config) {
  config = config || { };
  this.initalConfig = config;

  this.manager = config.manager;
  this.controller = config.controller;
  this.pluginPanels = {};
  this.listeners = config.listeners || {};

  /* Install the default response listener */
  this.addEvents('response', 'load');
  Ext.applyIf(this.listeners, {
    scope: this,
    'response': function(response, record, action, panel) {
      var message = response.flash || '';
      if(response.errors && response.errors.size() > 0) {
        if(message == '') { message = 'An error occured while saving...'; }
        Ext.each(response.errors, function(item) {
          message += "<br />" + Ext.util.Format.capitalize(item[0] + ' ' + item[1]);
        }, this);
      }
      if(message) { this.manager.notice({ msg: message }); }
    }
  });

  this.loadRequest = function(event, opts, request) {
    if(this.beforeFilter && this.beforeFilter.call(this, opts, request) === false) {
      return false;
    }
    if(this[event]) { this[event].call(this, opts, request); }
    if(this.afterFilter) { this.afterFilter.call(this, opts, request); }

    this.fireEvent('load', event, opts, request);
  }.createDelegate(this);

  this.navigation = function(request) {
    if(!request.action) { request.action = 'index'; }
    if(request.action) { this.loadRequest(request.action, request.params, request); }
  }.createDelegate(this);

  if(config.events) {
    this.addEvents(config.events);
  }

  function debug() {
    console.log('DEBUG: ', this.event, arguments);
  }

  if(config.debug && this.listeners) {
    for(var event in this.listeners) {
      this.on(event, debug, { event: event });
    }
  }
  Ext.ux.EventManager.superclass.constructor.call(this);
};
Ext.extend(Ext.ux.EventManager, Ext.util.Observable, {
  init: function(item) {
    item.em = this;
  }
});