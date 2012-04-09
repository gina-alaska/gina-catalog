Ext.define('App.view.help.index', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.helpindex',

  layout: 'fit',
  initComponent: function() {
  	if(!this.url) { this.url = 'http://catalog.northslope.org/cms/help'; }

  	Ext.apply(this, {
  	  html: '<iframe src="' + 
  	  	this.url + 
  	  	'" class="fulliframe">You browser does not support iframes</iframe>'
  	});

  	this.callParent();
  }
});