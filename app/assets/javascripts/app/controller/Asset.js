Ext.define('App.controller.Asset', {
  extend: 'Ext.app.Controller',

  views: ['asset.details', 'asset.map', 'asset.window'],
  models: ['Location'],
  stores: ['Locations'],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center catalogsidebar': {
        open: this.openWindow
      },
      'viewport > #center assetdetails': {
        show: function() {
          if(Ext.Msg.isVisible()) { Ext.Msg.hide(); }
        }
      },
      'viewport > #center #results-map': {
        featureclick: this.onFeatureClick
      },
      'assetwindow button[action="close"]': {
        click: function(button) {
          button.up('window').close();
        }
      },
      'assetwindow button[action="openfull"]': {
        click: function(button) {
          this.fullOpen(button.up('window').getRecord());
          button.up('window').close();
        }
      }
    });
  },

  start: function(panel) {
    this.pages = {};
    this.pages.details = panel.add({
      xtype: 'assetdetails',
      store: this.getStore('Locations')
    });
  },

  show: function() {
    /* This is a workaround to handle the slow loading of other cards when lots of results are shown */
    Ext.data.StoreManager.get('SearchResults').addHideAllFilter();
    var panel = this.pages.details.up('panel');
    panel.getLayout().setActiveItem(this.pages.details);
  },

  fullOpen: function(r) {
    var pbar = Ext.Msg.show({
      title: 'Please wait...',
      msg: 'Fetching record information',
      minWidth: 300,
      wait: true,
      modal: false
    });

    Ext.defer(this.showAssetDetails, 100, this, [r]);
  },

  openWindow: function(r) {
    var win = Ext.WindowManager.get('asset-window-' + r.get('id'));

    if(!win) {
      win = Ext.widget('assetwindow', {
        id: 'asset-window-' + r.get('id'),
        record: r
      });
    }
    win.show();
  },

  onFeatureClick: function(map, feature) {
    var store = this.getStore('SearchResults');
    var index = store.find('id', feature.attributes.id);
    if(index >= 0) {
      var r = store.getAt(index);
      this.openWindow(r);
    }
  },

  showAssetDetails: function(r) {
    this.show();

    var content = this.pages.details.getComponent('content');
    content.getLoader().load({
      url: '/catalog/' + r.get('id'),
      method: 'GET'
    });

    var store = this.getStore('Locations');
    store.setProxy({
      type: 'ajax',
      timeout: 120000,
      reader: { type: 'json' },
      autoLoad: false,
      url: '/catalog/' + r.get('id') + '/locations.json',
      method: 'GET'
    });

    this.pages.details.down('assetmap').getEl().mask('Loading...');
    this.getStore('Locations').load({
      scope: this,
      callback: function(records, op, success) {
        if(success) {
          this.pages.details.down('assetmap').loadLocations(records);
        }
      }
    });
  }
});