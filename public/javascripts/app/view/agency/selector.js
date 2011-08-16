Ext.define('App.view.agency.selector', {
  extend: 'Ext.gina.SelectorWindow',
  alias: 'widget.agencyselector',

  title: 'Select an Agency',
  layout: 'fit',
  width: 500,
  height: 500,
  store: 'App.store.Agencies',
  autoExpandColumn: 'name',
  columns: [
    { header: 'Acronym', dataIndex: 'acronym', width: 80 },
    { id: 'name', header: 'Name', dataIndex: 'name', width: 200 },
    { header: 'Category', dataIndex: 'category', width: 150 }
  ]
})