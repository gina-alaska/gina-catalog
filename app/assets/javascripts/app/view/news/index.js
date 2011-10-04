Ext.define('App.view.news.index', {
  extend: 'Ext.panel.Panel',
  alias: 'widget.newsindex',

  layout: {
    type: 'hbox',
    align: 'stretch'
  },
  html: '<iframe src="/cms/news" class="fulliframe">You browser does not support iframes</iframe>'
});