Ext.define('App.view.catalog.filterlist', {
  extend: 'Ext.view.View',
  alias: 'widget.filterlist',
  title: 'Search Filters',

  cls: 'filterlist',

  tpl: new Ext.XTemplate(
    '<tpl for=".">',
      '<div class="filter_wrap" id="filter_{id}">',
        '<div class="desc">{desc}</div>',
        '<div class="remove"><a id="{id}" action="remove" href="#"></a></div>',
      '</div>',
    '</tpl>'
  ),

  autoScroll: true,
  trackOver: true,
  overItemCls: 'x-item-over',
  itemSelector: 'div.filter_wrap',
  loadMask: true,
  loadingText: 'Loading filters...',
  singleSelect: true,
  allowDeselect: true,
  emptyText: 'No filters',
  layout: 'fit',

  initComponent: function() {
    this.store = Ext.data.StoreManager.lookup('Filters');
    this.callParent(arguments);
  }
});