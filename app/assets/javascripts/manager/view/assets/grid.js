/**
 * @class Manager.view.projects.Grid
 * @extends Ext.grid.Panel
 * Manager project list
 */
Ext.define('Manager.view.assets.Grid', {
    extend: 'Ext.grid.Panel',
    alias: 'widget.assets_grid',
    viewConfig: { loadMask: true },
    loadMask: true,
    columns: [
      { header: 'Title', dataIndex: 'title', flex: 2 },
      { header: 'Description', dataIndex: 'description', flex: 3 },
      { header: 'Geokeywords', dataIndex: 'geokeywords', flex: 1 },
      { header: 'Source', dataIndex: 'source_agency_acronym', flex: 1 },
      { header: 'Status', dataIndex: 'status', flex: 1 },
      { header: 'Added', dataIndex: 'created_at', flex: 1 },
      { header: 'Last Updated', dataIndex: 'updated_at', flex: 1 }
    ],
    
    initComponent: function() {
      Ext.apply(this, {
        dockedItems: [{
          xtype: 'assets_toolbar'
        },  {
          xtype: 'pagingtoolbar',
          store: this.getStore(),   // same store GridPanel is using
          dock: 'bottom',
          displayInfo: true
        }]
      });
      
      this.callParent(arguments);
    }, 
    
    listeners: {
      render: function() { this.getStore().load(); }
    }
});