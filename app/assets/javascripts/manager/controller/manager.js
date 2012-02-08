Ext.define('Manager.controller.Manager', {
  extend: 'Ext.app.Controller',
  stores: ['Projects'],
  routes: [{
    rule: 'project/:id',
    controller: 'Project',
    action: 'showRecord'
  }],
  
  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > panel[region="center"]': {
        render: this.start
      } 
    });
  },
  
  start: function(content) {
    this.panels = {};
    this.panels.index = content.add({
      itemId: 'manager',
      xtype: 'tabpanel',
      minTabWidth: 150,
      deferredRender: false,
      items: [{
        title: 'Projects',
        xtype: 'projects_grid',
        deferredRender: false,
        store: this.getStore("Projects")
      }, {
        title: 'Data'
      }, {
        title: 'Contacts'
      }, {
        title: 'Agencies'
      }]
    });
    
    content.getLayout().setActiveItem(this.panels.index);
    
    Ext.util.History.init(function() {
      var token = document.location.hash.replace('#', '');
      this.dispatch(token);
    }.bind(this));
    Ext.util.History.on('change', this.dispatch, this);
  },
  
  buildRoute: function(route){
    var match = [];
    Ext.each(route.rule.split('/'), function(item) {
      match.push(item.match(/^:/) ? '([^\\/]+)' : item);
    }, this);
    route.match = new RegExp('^' + match.join('\\/') + '$');
  },
  
  matchRoute: function(token){
    var match, route;
    
    Ext.each(this.routes, function(r) {
      route = r;
      match = token.match(route.match);
      if(match !== null) { return false; }
    }, this);
    return match ? this.decodeMatchedRoute(token, route, match) : false;
  },
  decodeMatchedRoute: function(token, route, match) {
    // Get rid of the elements we don't want from the matched rules
    match.shift();
        
    var params = {};
    Ext.each(route.rule.split('/'), function(item) {
      var name = item.match(/^:(.*)/);
      if(name) { params[name[1]] = match.shift(); }
    }, this);
    
    return {
      uri: token,
      controller: route.controller,
      action: route.action,
      params: params
    };
  },
  
  dispatch: function(token) {
    // Don't do anything if there is no token
    if(!token || token.length <= 0) {
      return false;
    }
    var request = this.matchRoute(token);
    if(request) {
      var controller = this.getController(request.controller);
      var action = controller[request.action];
      if(action) { action.call(controller, request); }      
    }
  }  
});
