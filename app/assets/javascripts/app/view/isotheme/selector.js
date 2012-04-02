Ext.define('App.view.isotheme.selector', {
  extend: 'Ext.gina.SelectorWindow',
  alias: 'widget.isothemeselector',

  title: 'Select an ISO Theme',
  layout: 'fit',
  width: 500,
  height: 500,
  store: 'App.store.IsoThemes',
  autoExpandColumn: 'name',
  columns: [
    { header: 'Code', dataIndex: 'iso_theme_code', flex: 1 },
    { id: 'name', header: 'Name', dataIndex: 'name', flex: 3 },
    { header: 'Description', dataIndex: 'long_name', flex: 5 }
  ]
});