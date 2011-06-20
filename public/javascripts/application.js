// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var App = function() {
  var _self = {};

  _self.controllers = new Ext.util.MixedCollection();
  _self.controllers.on('add', function(index, obj, key) {
    var klass = Ext.extend(Ext.ux.BaseController, obj);
    this.controllers.replace(key, new klass({ manager: this }));
  }, _self);

  _self.stores = new Ext.util.MixedCollection();
  _self.stores.on('add', function(index, obj, key) {
    this.stores.replace(key, Ext.create(obj, 'jsonstore'));
  }, _self);

  _self.views = new Ext.util.MixedCollection(true);

  _self.models = new Ext.util.MixedCollection(true);
  _self.models.on('add', function(index, obj, key) {
    this.models.replace(key, Ext.data.Record.create(obj));
  }, _self);

  Ext.apply(_self, {
    model: function(key) { return this.models.get(key); },
    controller: function(key) { return this.controllers.get(key); },
    view: function(key, params) {
      var v = this.views.get(key);
      return (typeof v == 'function' ? v.apply(_self, params) : v);
    },
    store: function(key) { return this.stores.get(key); },

    init: function() {
      Ext.QuickTips.init();
      this.nav = new Ext.ux.NavigationHandler({
        manager: this,
        defaultPage: 'home',
        autoStart: false,
        //appRootUrl: /^[\/]{0,1}$/,
        
        pages: {
          home: {
            title: 'Home',
            handler: this.controller('home').navigation,
            icon: '/images/icons/medium/home.png'
          },
          catalog: {
            title: 'Catalog',
            handler: this.controller('catalog').navigation,
            icon: '/images/icons/medium/bookmark.png'
          },
          news: {
            title: 'News',
            icon: '/images/icons/medium/chat-.png'
          },
          nssi: {
            title: 'NSSI',
            icon: '/images/icons/medium/globe.png'
          },
          realtime: {
            title: 'Realtime Data',
            icon: '/images/icons/medium/satellite.png'
          },
          contact: {
            title: 'Contact Us',
            icon: '/images/icons/medium/email.png'
          },
          help: {
            title: 'Help',
            icon: '/images/icons/medium/male-user.png'
          },
          signup: {
            title: 'Signup',
            url: 'http://id.gina.alaska.edu/#signup',
            mode: 'redirect',
            icon: '/images/icons/medium/agent.png'
          },
          login: {
            title: 'Login',
            url: '/login',
            icon: '/images/icons/medium/lock.png',
            mode: 'redirect'
          },
          logout: {
            title: 'Logout',
            url: '/logout',
            icon: '/images/icons/medium/lock.png',
            mode: 'redirect'
          }
        }
      });

      this.loadMask = new Ext.LoadMask(Ext.getBody(), {
        msg: 'Please wait...',
        store: App.store('search_results')
      });

      this.navToolbar = new Ext.ButtonGroup({
        border: false,
        columns: 3,
        height: 85,
        cls: 'main-menu',
        defaults: { scale: 'large', iconAlign: 'left', width: '100%', enableToggle: true, toggleGroup: 'pages' },
        items: [
          this.nav.toolbarItems(['catalog', 'news', 'nssi', 'realtime', 'contact', 'help'])
        ]
      });
      
      this.loginToolbar = new Ext.ButtonGroup({
        border: false,
        columns: 1,
        height: 85,
        cls: 'main-menu',
        defaults: { scale: 'large', iconAlign: 'left', width: '100%', enableToggle: true, toggleGroup: 'pages' },
        items: [
          this.nav.toolbarItems(['signup', 'login'])
        ]
      });

      this.topToolbar = new Ext.Toolbar({
        cls: 'main-toolbar',
        height: 90,
        items: [{
          border: false,
          xtype: 'panel',
          width: 550,
          contentEl: 'header'
        }, '->', this.navToolbar, this.loginToolbar]
      });

      this.views.add('content', new Ext.Panel({
        itemId: 'content',
        region: 'center',
        margins: '0 0 0 0',
        border: false,
        frame: false,
        layout: 'card',
        defaults: { border: false },
        activeItem: 0,
        tbar: this.topToolbar,
        items: [{ contentEl: 'content' }]
      }));

      this.current_user = new Ext.ux.User({
        url: '/preferences.json',
        method: 'GET',
        listeners: {
          scope: this,
          load: function() {
            var head = this.view('header'),
                bbar = this.loginToolbar,
                request = this.nav.getRequest(),
                items;

            if(this.current_user.logged_in()) {
              items = this.nav.toolbarItems([{
                xtype: 'panel',
                height: 37,
                border: false,
                cls: 'welcome-panel',
                html: 'Welcome back<br />' + this.current_user.get('fullname')
              }, 'logout']);
            } else {
              items = this.nav.toolbarItems(['signup', 'login']);
            }

            bbar.removeAll();
            bbar.add(items);
            bbar.doLayout();
          },
          clear: function() {
            var head = this.views.get('header'),
                bbar = this.loginToolbar,
                items = this.nav.toolbarItems(['signup', 'login']);
            
            bbar.removeAll();
            bbar.add(items);
            bbar.doLayout();
          }
        }
      });

      this.viewport = new Ext.Viewport({
        layout: 'border',
        border: false,
        frame: false,
        deferredRender: false,
        items: [ this.view('content') ]
      });

      this.current_user.on('load', function() { this.nav.start(); }, this, { single: true })
    }
  });

  return _self;
}();

Ext.onReady(App.init, App);