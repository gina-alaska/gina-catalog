App.views.add('home-welcome-window', new Ext.Window({
  width: 725,
  height: 525,
  layout: 'border',
  plain: true,
  id: 'splash-window',
  closable: false,

  defaults: { border: false, cls: 'transparent-bg' },
  cls: 'transparent-bg',
  items: [{
    region: 'north',
    contentEl: 'splash-header'
  }, {
    region: 'center',
    contentEl: 'splash-content',
    fbar: {
      buttonAlign: 'center',
      items: [{
        scale: 'large',
        text: 'Guest',
        handler: function(button) {
          App.nav.load('catalog/advanced', false, true);
          Ext.getCmp('splash-window').hide();
        }
      }, ' ',{
        scale: 'large',
        text: 'Login',
        handler: function() {
          App.nav.load('login', false, true);
          Ext.getCmp('splash-window').hide();
        }
      }]
    }
  }, {
    region: 'south',
    contentEl: 'splash-footer'
  }]
}));