Ext.define('App.view.news.index', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.newsindex',

  layout: 'fit',
  initComponent: function() {
  	Ext.apply(this, {
		  html: '<iframe src="http://catalog.northslope.org/cms/news" class="fulliframe">You browser does not support iframes</iframe>'
  	});

  	this.callParent();
  }
});