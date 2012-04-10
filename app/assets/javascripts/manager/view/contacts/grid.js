/**
 * @class Manager.view.contacts.grid
 * @extends Ext.grid.Panel
 * Agency grid
 */
Ext.define('Manager.view.contacts.grid', {
  extend: 'Ext.grid.Panel', 
  alias: 'widget.contacts_grid',
  viewConfig: { loadMask: true },
  loadMask: true,
  columns: [
    { header: 'First Name', dataIndex: 'first_name', flex: 2 },
    { header: 'Last Name', dataIndex: 'last_name', flex: 2 },
    { header: 'Email', dataIndex: 'email', flex: 2 },
    { header: 'Agencies', dataIndex: 'agencies', flex: 2 },
    { header: 'Last Updated', dataIndex: 'updated_at', flex: 1 }
  ],

  initComponent: function() {
    Ext.apply(this, {
      dockedItems: [{
        xtype: 'contacts_toolbar',
        dock: 'top'
      }, {
        xtype: 'pagingtoolbar',
        store: this.getStore(),   // same store GridPanel is using
        dock: 'bottom',
        displayInfo: true
      }]
    });
    this.callParent(arguments);
  }
});