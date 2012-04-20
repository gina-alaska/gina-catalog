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
      this.layout = 'hbox';
      this.items = [{
        flex: 1,
        cls: 'quicksearch',
        xtype: 'textfield',
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