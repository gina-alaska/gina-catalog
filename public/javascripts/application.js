//// Place your application-specific JavaScript functions and classes here
//// This file is automatically included by javascript_include_tag :defaults

Ext.Loader.setConfig({
  enabled: true,
  paths: {
    'Ext': '/javascripts',
    'App': '/javascripts/app',
    'Ext.OpenLayers': '/javascripts/openlayers'
  }
});
//
//Ext.require(['Ext.gina.Ajax', 'Ext.gina.NavigationHandler', 'Ext.gina.DefaultText', 'Ext.gina.Notify']);
//Ext.require(['Ext.OpenLayers.Layers', 'Ext.OpenLayers.Panel', 'App.model.CurrentUser', 'App.controller.*']);

Ext.define('App', {
  singleton: true,
  init: function(sys) {
    this.sys = sys;
    
    this.nav = Ext.create('Ext.gina.NavigationHandler', {
      manager: this,
      defaultPage: 'home',
      autoStart: false,
      appRootUrl: /^[\/]{0,1}$/,

      pages: {
        catalog: {
          title: 'Catalog',
          icon: '/images/icons/medium/bookmark.png'
        },
        news: {
          title: 'News',
          url: '/cms/news',
          mode: 'window',
          icon: '/images/icons/medium/chat-.png'
        },
        nssi: {
          title: 'NSSI',
          url: 'http://www.northslope.org',
          mode: 'window',
          icon: '/images/icons/medium/globe.png'
        },
        realtime: {
          title: 'Realtime Data',
          url: 'http://realtime.hub.gina.alaska.edu',
          mode: 'window',
          icon: '/images/icons/medium/satellite.png'
        },
        contact: {
          title: 'Contact Us',
          icon: '/images/icons/medium/email.png'
        },
        help: {
          title: 'Help',
          url: '/cms/help',
          mode: 'window',
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

    this.navToolbar = Ext.create('Ext.ButtonGroup', {
      border: false,
      columns: 3,
      height: 85,
      cls: 'main-menu',
      defaults: { scale: 'large', iconAlign: 'left', width: '100%', enableToggle: true, toggleGroup: 'pages' },
      items: [
        this.nav.toolbarItems(['catalog', 'news', 'nssi', 'realtime', 'contact', 'help'])
      ]
    });

    this.loginToolbar = Ext.create('Ext.ButtonGroup', {
      border: false,
      columns: 1,
      height: 85,
      cls: 'login-menu',
      buttonAlign: 'center',
      pack: 'center',
      defaults: { scale: 'large', iconAlign: 'left', width: '100%', enableToggle: true, toggleGroup: 'pages' },
      items: [
        this.nav.toolbarItems(['signup', 'login'])
      ]
    });

    this.header = Ext.create('Ext.toolbar.Toolbar', {
      cls: 'main-toolbar',
      items: [{
        width: 650,
        border: false,
        contentEl: 'header',
        xtype: 'panel'
      }, '->', this.navToolbar, this.loginToolbar]
    });

    this.current_user = Ext.create('Ext.gina.CurrentUser');
    this.current_user.on('logged_in', function() {
      var bbar = this.loginToolbar,
          items;

      items = this.nav.toolbarItems([{
        xtype: 'panel',
        height: 37,
        width: 150,
        border: false,
        cls: 'welcome-panel',
        html: 'Welcome back<br />' + this.current_user.get('fullname')
      }, 'logout']);

      bbar.removeAll();
      bbar.add(items);
    }, this);
  },

  showLoading: function(msg) {
    return Ext.Msg.show({
      title: 'Please wait...',
      msg: msg || 'Loading...',
      minWidth: 300,
      wait: true,
      modal: false
    });
  },
  hideLoading: function() { return Ext.Msg.hide(); }
});

Ext.application({
  name: 'App',
  appFolder: '/javascripts/app',
  controllers: ['Catalog', 'Asset', 'Contact', 'Video'],
  launch: function() {
    Ext.util.History.init();
    App.init(this);
    App.current_user.on('logged_out', function() {
      var splash = Ext.create(this.getController('Catalog').getView('catalog.splash'));
     	splash.show();
    }, this);

    App.viewport = Ext.create('Ext.container.Viewport', {
      layout: 'border',
      defaults: { border: false },
      items: [{
        id: 'center',
        region: 'center',
        border: false,
        tbar: App.header,
        layout: 'card',
        deferredRender: false,
        items: [{
          html: 'Loading...'
        }]
      }, {
        region: 'south',
        contentEl: 'footer'
      }]
    });

    if(top.location.pathname == '/') {
      var catalog = this.getController('Catalog');
      catalog.show();
    } else if(top.location.pathname.match(/^\/videos/) ) {
      var video = this.getController('Video');
      video.show();
    } else {
      var asset = this.getController('Asset');
      asset.show();
    }
  }
});