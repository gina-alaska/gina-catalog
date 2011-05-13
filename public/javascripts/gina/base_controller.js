Ext.ux.BaseController = Ext.extend(Ext.ux.EventManager, {
  constructor: function() {
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

  render: function(panel, replace) {
    var content = this.manager.view('content');

    if(replace === null || replace === undefined) {
      if(content.getLayout().setActiveItem) {
        replace = false;
      } else {
        replace = true;
      }
    }
    if(replace) { content.removeAll(); }

    if(typeof panel == 'string') {
      panel = this.manager.view(panel);
    }

    if(panel.rendered) {
      this.activePanel = content.add(panel);
    } else {
      this.activePanel = content.add(panel);
    }

    content.doLayout();
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