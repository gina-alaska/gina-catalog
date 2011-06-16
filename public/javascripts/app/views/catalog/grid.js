App.views.add('catalog-grid', function(config) {
  var _panel = {
    itemId: 'grid',
    region: 'center',
    xtype: 'grid',
    autoExpandColumn: 'title',
    loadMask: { msg: 'Loading....' },
    cm: new Ext.grid.ColumnModel({
      defaults: { sortable: true },
      columns: [{
        header: 'ID',
        dataIndex: 'id',
        hidden: true
      },{
        header: 'Type',
        dataIndex: 'type',
        hidden: true,
        width: 50
      },{
        id: 'title',
        header: 'Title',
        dataIndex: 'title',
        width: 100
      },{
        header: 'Source',
        dataIndex: 'source_agency_acronym',
        width: 50
      },{
        header: 'Status',
        dataIndex: 'status',
        width: 50
      },{
        header: 'Start',
        dataIndex: 'start_date_year',
        hidden: true,
        width: 50
      },{
        header: 'End',
        dataIndex: 'end_date_year',
        hidden: true,
        width: 50
      },{
        header: 'Created',
        dataIndex: 'created_at',
        hidden: true,
        width: 50
      },{
        header: 'Updated',
        dataIndex: 'updated_at',
        hidden: true,
        width: 50
      }]
    }),
    store: App.store('search_results'),
    listeners: {
      render: function(grid) {
        grid.getStore().load.defer(200, grid.getStore());
      }
    }
  };

  Ext.apply(_panel, config);

  return _panel;
});