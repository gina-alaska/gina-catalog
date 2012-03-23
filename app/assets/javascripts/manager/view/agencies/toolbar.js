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
          iconCls: 'search-icon',
          action: 'search',
          scale: 'medium'
        }]
      }, {
        xtype: 'buttongroup',
        items: [{
          xtype: 'button',
          tip: 'New Agency',
          iconCls: 'new-icon',
          action: 'new',
          scale: 'medium'
        }]
      }];        

      this.callParent(arguments);
    }
});