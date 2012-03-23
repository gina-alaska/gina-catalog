Ext.define('Manager.controller.Manager', {
  extend: 'Ext.app.Controller',
  stores: ['Projects', 'Assets', 'Agencies'],
  
  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > panel[region="center"]': {
        render: this.start
      } 
    });
  },
  
  start: function(content) {
    this.panels = {};
    this.panels.index = content.add({
      itemId: 'manager',
      xtype: 'tabpanel',
      minTabWidth: 150,
      maxTabWidth: 200,
      deferredRender: false,
      items: [{
        title: 'Projects',
        xtype: 'projects_grid',
        deferredRender: false,
        store: this.getStore("Projects")
      }, {
        title: 'Data',
        xtype: 'assets_grid',
        deferredRender: false,
        store: this.getStore("Assets")
      }, {
        title: 'Contacts'
      }, {
        title: 'Agencies',
        xtype: 'agencies_grid',
        deferredRender: true,
        store: Ext.create('Manager.store.Agencies')
      }]
    });
    
    content.getLayout().setActiveItem(this.panels.index);
  }
});
