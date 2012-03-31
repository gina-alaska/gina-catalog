/**
 * @class App.view.catalog.other_buttons
 * @extends Ext.container.ButtonGroup
 * Description
 */
Ext.define('App.view.catalog.other_buttons', {
  extend: 'Ext.container.ButtonGroup', 
  alias: 'widget.catalog_other_buttons',

  initComponent: function() {
    Ext.apply(this, {
      defaults: { scale: 'medium' },
      items: [{
        xtype: 'button',
        text: 'Sort',
        iconCls: 'sort-icon',
        menu: [{
          text: 'Title',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("title_sort","Sort by title")
        },{
          text: 'Project/Data',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("type","Sort by project/data")
        },{
          text: 'Source',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("source_agency_acronym","Sort by source agency")
        },{
          text: 'Status',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("status","Sort by status")
        },{
          text: 'Start Date',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("start_date_year","Sort by start date")
        },{
          text: 'End Date',
          group: 'sort', xtype: 'menucheckitem',
          hideOnClick: false,
          menu: this.directionMenu("end_date_year","Sort by end date")
        }]
      }, {
        xtype: 'button',
        text: 'Export',
        action: 'export',
        iconCls: 'download-icon'
      }]
    });        

    this.callParent(arguments);
  },

  directionMenu: function( val, description) {
    return [{
      text: 'Ascending',
      group: 'direction', xtype: 'menucheckitem',
      field: 'order_by',
      action: 'filter',
      filterType: 'single',
      value: val + "-asc",
      description: description + " ascending",
      immediateSearch: true,
      scope: this,
      checkHandler: this.checkHandler
    }, {
      text: 'Descending',
      group: 'direction', xtype: 'menucheckitem',
      field: 'order_by',
      action: 'filter',
      filterType: 'single',
      value: val + "-desc",
      description: description + " descending",
      immediateSearch: true,
      scope: this,
      checkHandler: this.checkHandler
    }];
  },

  checkHandler: function(menu, checked) {
    if(checked) {
      var parent = menu.parentMenu.parentItem;

      parent.setChecked(true);
    }
  }
});