Ext.define('App.view.help.index', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.helpindex',

  layout: {
    type: 'hbox',
    align: 'stretch'
  },
  html: '<iframe src="/cms/help" class="fulliframe">You browser does not support iframes</iframe>'
});