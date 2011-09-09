Ext.define('App.view.catalog.splash', {
  extend: 'Ext.window.Window',
  alias: 'widget.catalog_splash',
  width: 725,
  height: 525,
  layout: {
    type: 'vbox',
    align: 'stretch'
  },
  plain: true,
  closable: false,

  defaults: { border: false, cls: 'transparent-bg' },
  cls: 'transparent-bg',
  items: [{
    region: 'north',
    contentEl: 'splash-header'
  }, {
    region: 'center',
    autoScroll: true,
    flex: 1,
    contentEl: 'splash-content',
    docked: [{
      dock: 'bottom',
      buttonAlign: 'center',
      items: [{
        scale: 'large',
        text: 'Guest',
        xtype: 'button',
        handler: function(button) {
        }
      }, ' ',{
        scale: 'large',
        text: 'Login',
        xtype: 'button',
        handler: function() {
        }
      }]
    }]
  }, {
    region: 'south',
    border: false,
    contentEl: 'splash-footer'
  }]
});
