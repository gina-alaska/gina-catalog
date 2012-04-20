/**
 * @class Manager.view.agencies.Toolbar
 * @extends Ext.toolbar.Toolbar
 * Toolbar for the agencies editor
 */
Ext.define('Manager.view.agencies.Toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.agencies_toolbar',
    docked: 'top',
    
    initComponent: function() {
      this.layout = 'hbox';
      this.items = [{
        flex: 1,
        cls: 'quicksearch',
        xtype: 'textfield',
        name: 'query',
        plugins: [new Ext.gina.DefaultText({ text: 'Enter search here' })]
      }, {
        xtype: 'buttongroup',
        items: [{
          xtype: 'button',
          tip: 'Search',
          iconCls: 'blue-search',
          action: 'search',
          scale: 'large'
        }]
      }, {
        xtype: 'buttongroup',
        items: [{
          xtype: 'button',
          tip: 'New Project',
          iconCls: 'blue-add-item',
          action: 'new',
          scale: 'large'
        }]
      }];        

      this.callParent(arguments);
    }
});