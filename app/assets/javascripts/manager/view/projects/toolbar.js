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
          iconCls: 'search-icon',
          action: 'search',
          scale: 'medium'
        }]
      }, {
        xtype: 'buttongroup',
        items: [{
          xtype: 'button',
          tip: 'New Project',
          iconCls: 'new-icon',
          action: 'new',
          scale: 'medium'
        }]
      }];        

      this.callParent(arguments);
    }
});