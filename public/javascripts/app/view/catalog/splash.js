Ext.define('App.view.catalog.splash', {
  extend: 'Ext.window.Window',
  alias: 'widget.catalog_splash',
  width: 725,
  height: 525,

	layout: { type: 'vbox', align: 'stretch' },
	// layout: 'fit',
	
	modal: true,
  // plain: true,
  closable: false,
	preventHeader: true,
	// bodyBorder: false,

  // defaults: { border: false, cls: 'transparent-bg' },
  // cls: 'transparent-bg',
  items: [{
    dock: 'top',
		border: false,
		xtype: 'panel',
		height: 80,
    contentEl: 'splash-header'
  },	{
    autoScroll: true,
    flex: 1,
		border: false,
    contentEl: 'splash-content'
  }, {
		xtype: 'panel',
		border: false,
		layout: { type: 'hbox', pack: 'center' },
		defaults: { scale: 'large', width: 200, margin: '0 3 0 3' },
		items: [
			{ xtype: 'button', text: 'Guest', handler: function(button) { button.up('window').close(); } },
			{ xtype: 'button', text: 'Login', handler: function(button) { button.up('window').close(); } }
		]
	},	{
		dock: 'bottom',
		xtype: 'panel',
		border: false,
		layout: 'fit',
		height: 100,
    contentEl: 'splash-footer'
  }],
	// items: [{ html: 'test', border: false, bodyBorder: false }]
});
