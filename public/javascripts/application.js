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
        //appRootUrl: /^[\/]{0,1}$/,
        
        pages: {
          home: {
            title: 'Home',
            handler: this.controller('home').navigation,
            icon: '/images/icons/medium/home.png'
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

      this.views.add('content', new Ext.Panel({
        itemId: 'content',
        region: 'center',
        margins: '0 0 0 0',
        border: false,
        frame: false,
        layout: 'card',
        defaults: { border: false },
        activeItem: 0,
        items: [{ contentEl: 'content' }]
      }));

      this.views.add('header', new Ext.Panel({
        itemId: 'header',
        region: 'north',
        border: false,
        contentEl: 'header',
        bbar: {
          defaults: { scale: 'large', iconAlign: 'left', minWidth: 60, enableToggle: true, toggleGroup: 'pages' },
          items: [this.nav.toolbarItems(['signup', 'login'])]
        }
      }));

      this.current_user = new Ext.ux.User({
        url: '/preferences.json',
        method: 'GET',
        listeners: {
          scope: this,
          load: function() {
            var head = this.view('header'),
                bbar = head.getBottomToolbar(),
                request = this.nav.getRequest(),
                items;

            if(this.current_user.is_an_admin) {
              items = this.nav.toolbarItems(['tiles', 'radiometry', 'users', 'logout']);
            } else if(this.current_user.get('authorized?')) {
              items = this.nav.toolbarItems(['tiles', 'radiometry', 'logout']);
            } else {
              items = this.nav.toolbarItems(['logout']);
            }

            bbar.removeAll();
            bbar.add(items);
            bbar.doLayout();
          },
          clear: function() {
            var head = this.views.get('header'),
                bbar = head.getBottomToolbar(),
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
        items: [
          this.view('header'),
          this.view('content')
        ]
      });
    },

    selectControllerButton:function(controller) {
      var head = this.view('header'),
          bbar = head.getBottomToolbar(),
          index = bbar.items.findIndex('text', controller);

      bbar.items.get(index).toggle(true);
    }
  });

  return _self;
}();

Ext.onReady(App.init, App);