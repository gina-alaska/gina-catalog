/**
 * @class Manager.view.projects.Toolbar
 * @extends Ext.toolbar.Toolbar
 * Toolbar for the projects editor
 */
Ext.define('Manager.view.projects.Toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.projects_toolbar',
    docked: 'top',
    
    initComponent: function() {
      this.items = [{
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