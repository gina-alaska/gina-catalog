Ext.define('App.view.catalog.map', {
  alias: 'widget.catalog_map',
  extend: 'Ext.OpenLayers.Basic',

  config: {
    projection: "EPSG:3572",
    defaultZoom: 4
  },

  initComponent: function() {
    this.addEvents('featureclick', 'clusterclick', 'aoiadded', 'featuresrendered');

    this.addons = new Ext.util.MixedCollection(true);
    this.addon = function(name) { return this.addons.get(name); };
  
    this.vLayers = new Ext.util.MixedCollection(true);
    this.vLayers.on('add', this.onLayerAdd, this);
    this.layer = function(name) { return this.vLayers.get(name); };
    
    this.controls = new Ext.util.MixedCollection(true);
    this.controls.on('add', this.onControlAdd, this);
    this.control = function(name) { return this.controls.get(name); };

    this.callParent();
    
    this.on('ready', this.customizeMap, this);
  },
  
  styleFunctions: {
    context: {
      count: function(feature) {
        if (feature.attributes.title) { return ''; }

        var uniqueRec = [];
        Ext.each(feature.cluster, function(item) {
          if(uniqueRec.indexOf(item.attributes.id) < 0) {
            uniqueRec.push(item.attributes.id);
          }
        }, this);
        return uniqueRec.length;
      },
      radius: function(feature) {
        if(feature.attributes.count === undefined) {
          return 5;
        } else {
          return Math.min(Math.floor(feature.attributes.count / 10), 8) + 10;
        }
      }
    }
  },
  
  customizeMap: function() {
    this.controls.add('layers', new OpenLayers.Control.LayerSwitcher());   
    
    this.vLayers.add('aoi', {
      displayInLayerSwitcher: false,
      eventListeners: {
        beforefeaturesadded: function() { this.removeAllFeatures(); }
      }
    });
    this.controls.add('aoi', new OpenLayers.Control.DrawFeature(
      this.layer('aoi'),
      OpenLayers.Handler.RegularPolygon, {
        title: 'AOI: Click and drag the mouse to define your area of interest',
        handlerOptions: {
          irregular: true
        },
        eventListeners: { 
          featureadded: Ext.bind(this.onAOIAdd, this)
        }
      }
    )); 
    
    var pcluster = this.addons.add('project_cluster', new OpenLayers.Strategy.Cluster({ 
      distance: ((Ext.isIE6 || Ext.isIE7 || Ext.isIE8) ? 80: 40)
    }));
    var dcluster = this.addons.add('data_cluster', new OpenLayers.Strategy.Cluster({ 
      distance: ((Ext.isIE6 || Ext.isIE7 || Ext.isIE8) ? 80: 40)
    }));
    
    this.vLayers.add('Project', {
      isBaseLayer: false,
      strategies: [ pcluster ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          label: (Ext.isIE6 || Ext.isIE7 || Ext.isIE8) ? false : "${count}",
          pointRadius: "${radius}",
          fillColor: "#94fbff",
          fillOpacity: 0.3,
          graphicName: 'circle',
          strokeColor: '#0000FF',
          strokeWidth: 2,
          strokeOpacity: 1
        }, this.styleFunctions),
        "select": new OpenLayers.Style({
          fillColor: "#F00",
          strokeColor: '#F00'
        })
      }),
      rendererOptions: { zIndexing: true }
    });
    
    this.vLayers.add('Data', {
      isBaseLayer: false,
      strategies: [ dcluster ],      
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          label: (Ext.isIE6 || Ext.isIE7 || Ext.isIE8) ? false : "${count}",
          graphicName: 'circle',
          pointRadius: "${radius}",
          fillColor: "#ffcc66",
          fillOpacity: 0.3,
          strokeColor: '#cc6633',
          strokeWidth: 2,
          strokeOpacity: 1
        }, this.styleFunctions),
        "select": new OpenLayers.StyleMap({
          fillColor: "#F00",
          strokeColor: '#F00'
        })
      }),
      rendererOptions: { zIndexing: true }
    });
    
    /* User clicks on a polygon for point on the map */
    this.controls.add('select', new OpenLayers.Control.SelectFeature(
      [this.layer('Project'), this.layer('Data')],
      {
        clickout: true,
        onSelect: Ext.bind(this.onFeatureClick, this)
      }
    ));
    this.control('select').activate();
  },
  
  loadFeaturesFrom: function(store) {
    this.store = store;
    this.store.on('datachanged', this.loadFeatures, this);
  },
  
  loadFeatures: function() {
    var project = [], data = [], features;
    var pLayer = this.layer('Project');
    var dLayer = this.layer('Data');
    
    pLayer.removeAllFeatures();
    dLayer.removeAllFeatures();
    this.addon('project_cluster').clearCache();
    this.addon('data_cluster').clearCache();
    this.addon('project_cluster').activate();
    this.addon('data_cluster').activate();
    
    this.store.each(function(item) {
      features = this.buildFeatures(item.get('id'), item.get('locations'));
      
      if(features.length > 0 && item.get('type') == 'Project') {
        project = project.concat(features);
      } else {
        data = data.concat(features);
      }
    }, this);
    if(project.length > 0) { pLayer.addFeatures(project); }
    if(data.length > 0) { dLayer.addFeatures(data); }
  },

  loadRecordFeatures: function(record) {
    var pLayer = this.layer('Project');
    var dLayer = this.layer('Data');

    pLayer.removeAllFeatures();
    dLayer.removeAllFeatures();
    this.addon('project_cluster').clearCache();
    this.addon('data_cluster').clearCache();
    this.addon('project_cluster').deactivate();
    this.addon('data_cluster').deactivate();
    

    var features = this.buildFeatures(record.get('id'), record.get('locations'));

    if(features.length > 0 && record.get('type') == 'Project') {
      pLayer.addFeatures(features);
    } else {
      dLayer.addFeatures(features);
    }
  },

  buildFeatures: function(key, locations) {
    var wkt = new OpenLayers.Format.WKT();
    var fromProj = new OpenLayers.Projection('EPSG:4326');
    var toProj = this.getMap().getProjectionObject();
    
    var features = [];
    Ext.each(locations, function(l) {
      //Skip items without a WKT
      if(l.wkt === null) { return; }
      var f = wkt.read(l.wkt);
      f.attributes.id = key;
      
      //Transform to the map projection from LatLng
      f.geometry.transform(fromProj, toProj);
      features.push(f); 
    }, this);
    
    return features;
  },
  
  createVLayer: function(name, config){
    return new OpenLayers.Layer.Vector(name, config);
  },
  
  onLayerAdd: function(index, obj, key, opts) {
    var layer = this.createVLayer(key, obj);
    this.getMap().addLayer(layer);
    this.vLayers.replace(key, layer);
  },
  
  onControlAdd: function(index, obj, key, opts) {
    this.getMap().addControl(obj);
  },
  
  onAOIAdd: function(e){
    this.fireEvent('aoiadded', this, e.feature);
  },
  
  onFeatureClick: function(feature) {
    if(feature.cluster) {
      this.fireEvent('clusterclick', this, feature);
    } else {
      this.fireEvent('featureclick', this, feature);
    }
  }
});
