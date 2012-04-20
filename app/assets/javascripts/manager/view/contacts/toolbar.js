/**
 * @class Manager.view.contacts.Toolbar
 * @extends Ext.toolbar.Toolbar
 * Toolbar for the contacts editor
 */
Ext.define('Manager.view.contacts.Toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.contacts_toolbar',
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