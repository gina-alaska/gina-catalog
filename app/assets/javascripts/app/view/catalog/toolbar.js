/**
 * @class App.view.catalog.toolbar
 * @extends Ext.toolbar.Toolbar
 * Filter toolbar for the catalog
 */
Ext.define('App.view.catalog.toolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.catalog_toolbar',

    initComponent: function() {
      Ext.apply(this, {
        layout: 'hbox',
        items: [{
          flex: 1,
          name: 'q',
          cls: 'quicksearch',
          xtype: 'textfield',
          hideLabel: true,
          plugins: [new Ext.gina.DefaultText({text: 'Enter search terms here'})]
        },{
          xtype: 'catalog_text_search'
        }, { 
          xtype: 'catalog_search_buttons' 
        }, {
          xtype: 'catalog_other_buttons'
        }]
      });

      this.callParent(arguments);
    }
});