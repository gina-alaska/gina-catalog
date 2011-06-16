Ext.ux.BaseController = Ext.extend(Ext.ux.EventManager, {
  constructor: function() {
    this.panels = new Ext.util.MixedCollection();
    
    Ext.ux.BaseController.superclass.constructor.apply(this, arguments);
    Ext.util.Observable.capture(this, this.onLoad, this);
  },

  onLoad: function(event, opts) {
    if(this[event]) { return this.fireEvent('load', event, opts); }
    return true;
  },

  refresh: function(url) {
    if(!url) {
      top.window.location = unescape(window.location.pathname);
    } else {
      top.window.location = url;
    }
  },

  redirectTo: function(hash) {
    this.manager.nav.load(hash)
  },

  usingCardLayout: function() {
    if(this.manager.view('content').getLayout().setActiveItem) {
      return true;
    } else {
      return false;
    }
  },

  findPanel: function(panel, params) {
    if(typeof panel == 'string') {
      if(this.panels.get(panel)) {
        return this.panels.get(panel);
      } else {
        return this.manager.view(panel, params);
      }
    } else {
      return panel;
    }
  },

  render: function(panel, params) {
    var content = this.manager.view('content'),
        requestedPanel=this.findPanel(panel, params);

    if(!this.usingCardLayout()) { content.removeAll(); }

    if(requestedPanel.rendered) {
      this.activePanel = requestedPanel;
    } else {
      this.activePanel = content.add(requestedPanel);
      content.doLayout();
      
      if(typeof panel == 'string') {
        this.panels.add(panel, this.activePanel);
      } else {
        this.panels.add(this.activePanel.getId(), this.activePanel);
        if(console && console.log) {
          console.log('Please update your code to add panels by name, adding panel objects is deprecated');
        }
      }
    }

    this.activate(this.activePanel);
    return this.activePanel;
  },

  activate: function(panel) {
    var content = this.manager.view('content');

    if(content.getLayout().setActiveItem) {
      content.getLayout().setActiveItem(panel);
    }
  },

  renderHTML: function(html, replace) {
    this.render({ "html": html }, replace);
  },

  renderURL: function(params, replace) {
    Ext.applyIf(params, {
      method: 'GET',
      listeners: {
        scope: this,
        success: function(xhr, opts) {
          this.renderHTML(xhr.responseText);
        }
      }
    });
    Ext.ux.Ajax.request(params);
  }
});