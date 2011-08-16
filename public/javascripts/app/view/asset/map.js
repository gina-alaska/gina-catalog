Ext.define('App.view.asset.map', {
  extend: 'Ext.OpenLayers.Panel',
  alias: 'widget.assetmap',

  tbar: false,
  fbar: false,
  projection: 'google',
  enableGraticule: false,

  initComponent: function() {
    this.callParent();
    this.on('ready', this.setupLayers, this);
  },

  setupLayers: function() {
    this.locations = new OpenLayers.Layer.Vector('Locations');
    this.addLayer(this.locations);
  },

  loadLocations: function(records) {
    var features = [];

    this.locations.removeAllFeatures();
    
    Ext.each(records, function(r) {
      if(r.get('wkt') !== null) {
        var geom = new OpenLayers.Geometry.fromWKT(r.get('wkt'));
        geom.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
        features.push(new OpenLayers.Feature.Vector(geom, r.data));
      }
    }, this);

    this.locations.addFeatures(features);
    var bounds = this.locations.getDataExtent();
    if(bounds) { this.fit(bounds, 4); }

    this.getEl().unmask();
  }
});