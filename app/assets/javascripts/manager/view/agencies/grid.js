/**
 * @class Manager.view.agencies.grid
 * @extends Ext.grid.Panel
 * Agency grid
 */
Ext.define('Manager.view.agencies.grid', {
  extend: 'Ext.grid.Panel', 
  alias: 'widget.agencies_grid',
  viewConfig: { loadMask: true },
  loadMask: true,
  columns: [
    { header: 'Name', dataIndex: 'name', flex: 3 },
    { header: 'Acronym', dataIndex: 'acronym', flex: 1 },
    { header: 'Category', dataIndex: 'category', flex: 1 },
    { header: 'Last Updated', dataIndex: 'updated_at', flex: 1 }
  ],

  initComponent: function() {
    Ext.apply(this, {
      dockedItems: [{
        xtype: 'agencies_toolbar',
        dock: 'top'
      }]
    });
    this.callParent(arguments);
  }, 

  listeners: {
    render: function() { this.getStore().load(); }
  }
});