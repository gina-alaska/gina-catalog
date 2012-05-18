Ext.define('App.view.person.selector', {
  extend: 'Ext.gina.SelectorWindow',
  alias: 'widget.personselector',

  title: 'Select a Contact',
  layout: 'fit',
  width: 500,
  height: 500,
  store: 'App.store.People',
  autoExpandColumn: 'full_name',
  columns: [
    { id: 'full_name', header: 'Full Name', dataIndex: 'full_name', flex: 1 },
    { header: 'Email', dataIndex: 'email', flex: 3 }
  ]
})