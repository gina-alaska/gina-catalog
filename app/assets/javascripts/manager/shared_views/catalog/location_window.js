/**
 * @class Manager.shared_views.catalog.LocationWindow
 * @extends Ext.window.Window
 * Window for editing locations
 */
Ext.define('Manager.shared_views.catalog.LocationWindow', {
  extend: 'Ext.window.Window', 
  alias: 'widget.location_window',

  initComponent: function() {
    this.addEvents('save');

    Ext.apply(this, {
      title: 'Edit Location',
      width: 600,
      height: 600,
      layout: 'fit',
      dockedItems: [{
        ui: 'footer',
        dock: 'bottom',
        xtype: 'toolbar',
        defaults: { scale: 'large', width: 50 },
        items: ['->', { 
          text: 'Cancel', 
          handler: function() { 
            this.up('window').close(); 
          } 
        }, { 
          text: 'Save', 
          scope: this,
          handler: function() {
            if(this.drawlayer.features[0]) {
              var feature = this.drawlayer.features[0].clone();
              feature.geometry.transform(this.map.getProjectionObject(), this.map.displayProjection);

              var wkt = new OpenLayers.Format.WKT();
              this.fireEvent('save', this, wkt.write(feature));              
            } else {
              this.fireEvent('save', this, '');              
            }
          }
        }]
      }, {
        itemId: 'tools',
        dock: 'top',
        xtype: 'toolbar',
        items: [
          { itemId: 'clear', text: 'Clear', iconCls: 'small-cancel', 
            handler: this.draw, scope: this },
          { itemId: 'point', text: 'Point', toggleGroup: 'geom', iconCls: 'geo-bullet_red', 
            toggleHandler: this.draw, scope: this }, 
          { itemId: 'polygon', text: 'Polygon', toggleGroup: 'geom', iconCls: 'geo-shape_square_red', 
            toggleHandler: this.draw, scope: this }
        ]
      }],
      items: [{
        xtype: 'openlayers',
        border: false,
        projection: 'EPSG:3338',
        listeners: {
          ready: { scope: this, fn: this.setupMap }
        }
      }]
    });

    this.callParent(arguments);
  },

  draw: function(button, pressed){
    if(pressed) {
      this.drawlayer.removeAllFeatures();
    }
    switch(button.text) {
      case "Clear": 
        this.drawlayer.removeAllFeatures();
        break;
      case "Point":
        this.polygonDraw.deactivate();
        if(pressed) {
          this.pointDraw.activate();
        } else {
          this.pointDraw.deactivate();
        }
        break;
      case "Polygon":
        this.pointDraw.deactivate();
        if(pressed) {
          this.polygonDraw.activate();
        } else {
          this.polygonDraw.deactivate();
        }
        break;
    }
  },

  setupMap: function(mapPanel){
    this.map = mapPanel.getMap();

    this.drawlayer = new OpenLayers.Layer.Vector('draw');
    this.map.addLayer(this.drawlayer);

    toolconfig = {
      eventListeners: { featureadded: Ext.bind(this.featureAdded, this) }
    };
    this.pointDraw = new OpenLayers.Control.DrawFeature(this.drawlayer, OpenLayers.Handler.Point, toolconfig);
    this.map.addControl(this.pointDraw);
    this.polygonDraw = new OpenLayers.Control.DrawFeature(this.drawlayer, OpenLayers.Handler.Polygon, toolconfig);
    this.map.addControl(this.polygonDraw);
	
  // this.selectFeature = new OpenLayers.Control.SelectFeature(this.drawlayer, { toggle: false });
  // this.map.addControl(this.selectFeature);
  // this.selectFeature.activate();
	
  	this.editFeature = new OpenLayers.Control.ModifyFeature(this.drawlayer, {
      toggle: false,
  	  standalone: true
  	});
  	this.map.addControl(this.editFeature);
  	this.editFeature.activate();
	
    if(this.field && this.field.getValue()) {
      var wkt = new OpenLayers.Format.WKT();
      var feature = wkt.read(this.field.getValue());
      feature.geometry.transform(this.map.displayProjection, this.map.getProjectionObject());
      this.drawlayer.addFeatures(feature);
      // this.selectFeature.clickFeature(feature);
  	  this.editFeature.selectFeature(feature);
    }
  },

  featureAdded: function(e) {
    switch(e.object.handler.CLASS_NAME) {
      case 'OpenLayers.Handler.Point': 
        this.down('#tools').down('#point').toggle(false);
        break;
      case 'OpenLayers.Handler.Polygon': 
        this.down('#tools').down('#polygon').toggle(false);
        break;
    }
    e.object.deactivate();
    // this.selectFeature.clickFeature(feature);
	  this.editFeature.selectFeature(e.feature);
  }
});