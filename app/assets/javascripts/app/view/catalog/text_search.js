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
      defaults: { scale: 'large' },
      items: [{
        xtype: 'button',
        iconCls: 'blue-x',
        action: 'clear_text'
      }, {
        xtype: 'button',
        iconCls: 'blue-search',
        action: 'search'
      }]
    });

    this.callParent(arguments);
  }
});