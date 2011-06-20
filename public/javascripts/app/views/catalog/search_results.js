App.views.add('catalog-search-results', function(config) {
  var sortHandler = function(menu, checked) {
    menu.ownerCt.ownerCt.setChecked(checked);
    var pbar = Ext.Msg.show({
      title: 'Please wait...',
      msg: 'Sorting results...',
      minWidth: 300,
      wait: true,
      modal: false
    });

    App.store('search_results').sort.defer(100, App.store('search_results'), [menu.ownerCt.ownerCt.dataIndex, menu.text.toUpperCase()]);
  };

  var directionMenu = [{
    text: 'Asc',
    group: 'direction', xtype: 'menucheckitem',
    checkHandler: sortHandler
  }, {
    text: 'Desc',
    group: 'direction', xtype: 'menucheckitem',
    checkHandler: sortHandler
  }];


  var _panel = {
    layout: 'fit',
    tbar: [{
      xtype: 'buttongroup',
      items: [{
        text: 'Sort',
        scale: 'medium',
        icon: '/images/icons/small/table_sort.png',
        menu: [{
          text: 'Title',
          dataIndex: 'title',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        },{
          text: 'Type',
          dataIndex: 'type',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        },{
          text: 'Source',
          dataIndex: 'source_agency_acronym',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        },{
          text: 'Status',
          dataIndex: 'status',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        },{
          text: 'Start',
          dataIndex: 'start_date_year',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        },{
          text: 'End',
          dataIndex: 'end_date_year',
          group: 'sort', xtype: 'menucheckitem',
          menu: directionMenu
        }]
      }]
    }],
    items: App.view('catalog-list', [{
      store: App.store('search_results')
    }])
  }

  Ext.apply(_panel, config);

  return _panel;
});