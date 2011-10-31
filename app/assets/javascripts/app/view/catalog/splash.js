Ext.define('App.view.catalog.splash', {
  extend: 'Ext.window.Window',
  alias: 'widget.catalog_splash',
  width: 725,
  height: 500,

  layout: { type: 'vbox',align: 'stretch' },

  modal: true,
  closable: false,
  preventHeader: true,

  items: [{
    dock: 'top',
    border: false,
    xtype: 'panel',
    height: 80,
    contentEl: 'splash-header'
  },{
    autoScroll: true,
    flex: 1,
    border: false,
    contentEl: 'splash-content'
  },{
    itemId: 'loading',
    bodyStyle: 'text-align: center; font-size: 20px;',
    xtype: 'panel',
    border: false,
    html: 'Please wait loading records... <img src="/assets/loading.gif" />'
  }, {
    itemId: 'buttons',
    hidden: true,
    xtype: 'panel',
    border: false,
    layout: { type: 'hbox',pack: 'center' },
    defaults: { scale: 'large',width: 200, margin: '0 3 0 3' },
    items: [{
      xtype: 'button',
      cls: 'enter-button',
      text: 'Enter the Catalog',
      handler: function(button) { button.up('window').close(); }
    }]
  },{
    dock: 'bottom',
    xtype: 'panel',
    border: false,
    layout: 'fit',
    height: 100,
    contentEl: 'splash-footer'
  }],
  
  recordsLoaded: function() {
    this.loaded = true;
  },
  
  featuresRendered: function() {
    if(this.loaded) { this.showButtons(); }
  },
  
  showButtons: function() {
    if(this.isVisible()) {
      this.getComponent('loading').hide();
      this.getComponent('buttons').show();
    }
  }
});
