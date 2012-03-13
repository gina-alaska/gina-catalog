/**
 * @class Manager.view.assets.Toolbar
 * @extends Ext.toolbar.Toolbar
 * Toolbar for the projects editor
 */
Ext.define('Manager.view.assets.Toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.assets_toolbar',
    docked: 'top',
    
    initComponent: function() {
      this.items = [{
        xtype: 'button',
        text: 'New Asset',
        action: 'new'
      },'->', {
        xtype: 'textfield',
        width: 300,
        plugins: [new Ext.gina.DefaultText({ text: 'Enter search here' })]
      }, {
        xtype: 'button',
        text: 'Search',
        action: 'search'
      }];        

      this.callParent(arguments);
    }
});