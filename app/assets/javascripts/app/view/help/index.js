Ext.define('App.view.help.index', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.helpindex',

  layout: 'fit',
  html: '<iframe src="http://catalog.northslope.org/cms/help" class="fulliframe">You browser does not support iframes</iframe>'
});