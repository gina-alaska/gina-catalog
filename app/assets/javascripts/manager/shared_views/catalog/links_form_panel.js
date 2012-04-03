/**
* @class Manager.shared_views.catalog.links_form_panel
* @extends Ext.panel.Panel
* Shared view for links form panel
*/
Ext.define('Manager.shared_views.catalog.links_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_links_form_panel',

  initComponent: function() {
    Ext.apply(this, {
      dockedItems: [{
        xtype:'toolbar',
        dock: 'top',
        defaults: { scale: 'large' },
        items: [{ text: '<b>New Link</b>', action: 'add_link' }]
      }]
    });        

    this.callParent(arguments);
  }
});