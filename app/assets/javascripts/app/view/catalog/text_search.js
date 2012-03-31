/**
 * @class App.view.catalog.text_search
 * @extends Ext.container.ButtonGroup
 * Description
 */
Ext.define('App.view.catalog.text_search', {
  extend: 'Ext.container.ButtonGroup', 
  alias: 'widget.catalog_text_search',

  initComponent: function() {
    Ext.apply(this, {
      defaults: { scale: 'medium' },
      items: [{
        xtype: 'button',
        iconCls: 'cancel-icon',
        action: 'clear_text'
      }, {
        xtype: 'button',
        iconCls: 'search-icon',
        action: 'search'
      }]
    });

    this.callParent(arguments);
  }
});