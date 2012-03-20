Ext.define('App.view.catalog.show', {
  alias: 'catalog.show',
  extend: 'Ext.window.Window',
  constrain: true,
  layout: 'fit',
  items: [{
    itemId: 'content',
    html: 'stuff goes here'
  }]
});