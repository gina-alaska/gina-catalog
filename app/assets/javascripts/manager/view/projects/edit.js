/**
 * @class Manager.view.project.Edit
 * @extends Ext.panel.Panel
 * Edit Panel for Projects
 */
Ext.define('Manager.view.project.Edit', {
    extend: 'Ext.panel.Panel', 
    alias: 'widget.project_edit',

    initComponent: function() {
      Ext.apply(this, {
        title: 'Loading...',
        layout: 'fit',
        items: [{
          html: 'Loading...'
        }]
      });        

      this.callParent(arguments);
    }
});