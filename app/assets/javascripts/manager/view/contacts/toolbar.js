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