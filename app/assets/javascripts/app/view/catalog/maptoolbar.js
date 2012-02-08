/**
 * @class App.view.catalog.maptoolbar
 * @extends Ext.toolbar.Toolbar
 * Map toolbar
 */
Ext.define('App.view.catalog.maptoolbar', {
    extend: 'Ext.toolbar.Toolbar', 
    alias: 'widget.catalog_maptoolbar',

    initComponent: function() {
      Ext.apply(this, {
        ui: 'footer',
        items: [
          'Lat: ', 
          { xtype: 'textfield', name: 'lat', width: 100 },
          'Lon:', 
          { xtype: 'textfield', name: 'lon', width: 100 },
          { text: 'Go', xtype: 'button', action: 'move' }
        ]
      });
      
      if(!Ext.isIE) {
        this.items.push('->');
        this.items.push({
          border: false,
          xtype: 'panel',
          bodyStyle: 'padding: 3px; white-space:nowrap;',
          itemId: 'mouse',
          tpl: new Ext.Template("Mouse: ({lat:round(3)}, {lon:round(3)})")
        });
        this.items.push({
          border: false,
          xtype: 'panel',
          bodyStyle: 'padding: 3px; white-space:nowrap;',
          itemId: 'center',
          tpl: new Ext.Template("Center: ({lat:round(3)}, {lon:round(3)})")
        });
      }

      this.callParent(arguments);
    },
    
    updateMouse: function(point){
      var panel = this.down('panel[itemId="mouse"]');
      if (panel) { panel.update(panel.tpl.apply(point)); }
    },
    
    updateCenter: function(point){
      var panel = this.down('panel[itemId="center"]');
      if(panel) { panel.update(panel.tpl.apply(point)); }
    }
});
