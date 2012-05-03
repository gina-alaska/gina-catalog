/**
 * @class Manager.shared_views.catalog.info_panel
 * @extends Ext.panel.Panel
 * Info panel for items
 */
Ext.define('Manager.shared_views.catalog.info_panel', {
    extend: 'Ext.panel.Panel', 
    alias: 'widget.catalog_info_panel',

    initComponent: function() {
      Ext.apply(this, {
        items: [{
          xtype: 'displayfield',
          fieldLabel: 'Created',
          name: 'created_at'
        }, {
          xtype: 'displayfield',
          fieldLabel: 'Updated',
          name: 'updated_at'
        }, {
          xtype: 'displayfield',
          fieldLabel: 'Published',
          name: 'published_at'
        }, {
          xtype: 'displayfield',
          fieldLabel: 'Git URL',
          name: 'repo_slug',
          renderer: function(value, field) {
            return '<a href="/repos/' + value + '.git" target="_blank">' + value + '</a>';
          }
        }]
      });        

      this.callParent(arguments);
    }
});