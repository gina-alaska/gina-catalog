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
    
    this.vLayers.add('selection', {
      displayInLayerSwitcher: false,
      eventListeners: {
        beforefeaturesadded: function() { this.removeAllFeatures(); }
      }
    });
    this.controls.add('aoi', new OpenLayers.Control.DrawFeature(
      this.layer('selection'),
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
      distance: (Ext.isIE ? 80: 40)
    }));
    var dcluster = this.addons.add('data_cluster', new OpenLayers.Strategy.Cluster({ 
      distance: (Ext.isIE ? 80: 40)
    }));
    
    this.vLayers.add('Project', {
      isBaseLayer: false,
      strategies: [ pcluster ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          label: Ext.isIE ? false : "${count}",
          pointRadius: "${radius}",
          fillColor: "#94fbff",
          fillOpacity: 0.2,
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
          label: Ext.isIE ? false : "${count}",
          graphicName: 'circle',
          pointRadius: "${radius}",
          fillColor: "#ffcc66",
          fillOpacity: 0.2,
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
/*
  setup: function() {
    this.setupLayers();
    this.setupControls();
  },
  
  buildFeatures: function(r) {
    var features = [];
    Ext.each(r.get('locations'), function(loc) {
      var f = this.buildVectorFeature(loc.wkt, r);
      if(f !== null) { features.push(f);}
    }, this);
    
    return features;
  },
  
  buildVectorFeature: function(wkt, r) {
    if(wkt !== null) {
      var geom = new OpenLayers.Geometry.fromWKT(wkt);
      var point = geom;
      // var point = geom.getCentroid();
      point.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
      return new OpenLayers.Feature.Vector(point, { id: r.data.id, title: r.data.title });
    }
    return null;
  },  

  setupControls: function() {
    this.controls.add('select_item', new OpenLayers.Control.SelectFeature(
      [this.projects,this.data],
      {
        clickout: true,
        onSelect: Ext.bind(this.onFeatureClick, this)
      }
    ));
    this.control('select_item').activate();

    this.store.on('removefilter', this.onFilterRemove, this);
  },

  onFilterRemove: function(store, name) {
    if(name == 'aoi' || name == 'all') {
      this.selectionLayer.removeAllFeatures();
    }
  },

  setupLayers: function() {
//    this.getMap().addLayer(this.gina.getLayer('landownership'));
//    var geojson = new OpenLayers.Format.GeoJSON();
//    var alaska = geojson.read(SearchRegions.alaska)[0];
//    var nsb = geojson.read(SearchRegions.nsb)[0];
//    alaska.geometry.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
//    nsb.geometry.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
//
//    this.regions = new OpenLayers.Layer.Vector('Regions', {});
//    this.regions.addFeatures([alaska]);
//    this.addLayer(this.regions);

    // this.featureCache = Ext.create('Ext.util.MixedCollection');
    
    var styleFunctions = {
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
    };
    
    // this.soslayer = new OpenLayers.Layer.SOS('Test', 'http://hermes.gina.alaska.edu/map/sostest');
    // this.addLayer(this.soslayer);
    // var sos = new OpenLayers.SOSClient({map: this.getMap(), url: 'http://hermes.gina.alaska.edu/map/sostest'});

    this.project_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: (Ext.isIE ? 80: 40) });
    this.projects = new OpenLayers.Layer.Vector('Projects', {
      strategies: [ this.project_cluster_strategy ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          label: Ext.isIE ? false : "${count}",
          // fontWeight: 'bold',
          pointRadius: "${radius}",
//          pointRadius: 4,
          fillColor: "#94fbff",
          fillOpacity: 0.3,
          graphicName: 'circle',
          strokeColor: '#0000FF',
          strokeWidth: 2,
          strokeOpacity: 1
        }, styleFunctions),
        "select": new OpenLayers.StyleMap({
          fillColor: "#F00",
          strokeColor: '#F00'
        })
      }),
      rendererOptions: { zIndexing: true }
    });
    this.addLayer(this.projects);

    this.data_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: (Ext.isIE ? 80: 40) });
    this.data = new OpenLayers.Layer.Vector('Data', {
      strategies: [ this.data_cluster_strategy ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          label: Ext.isIE ? false : "${count}",
          // fontWeight: 'bold',
          graphicName: 'circle',
          pointRadius: "${radius}",
          fillColor: "#ffcc66",
          fillOpacity: 0.3,
          strokeColor: '#cc6633',
          strokeWidth: 2,
          strokeOpacity: 1
        }, styleFunctions),
        "select": new OpenLayers.StyleMap({
          fillColor: "#F00",
          strokeColor: '#F00'
        })
      }),
      rendererOptions: { zIndexing: true }
    });
    this.addLayer(this.data);
  },

  onFeatureClick: function(feature) {
    if(feature.cluster) {
      this.fireEvent('clusterclick', this, feature);
    } else {
      this.fireEvent('featureclick', this, feature);
    }
  },

  showSelectedFeature: function(id) {
    var projects = [];
    var data = [];

    var pbar = Ext.Msg.show({
      title: 'Please wait...',
      msg: 'Adding locations to the map',
      minWidth: 300,
      wait: true,
      modal: false
    });

    this.projects.removeAllFeatures();
    this.data.removeAllFeatures();

    this.project_cluster_strategy.deactivate();
    this.data_cluster_strategy.deactivate();
//    this.control('select_item').deactivate();

    var index = this.store.find('id', id),
        r = this.store.getAt(index),
        features = this.buildFeatures(r); //r.get('features');

    if(features.length > 0) {
      var bounds;
      
      if(r.get('type') == 'Project') {
        this.projects.addFeatures(features);
        bounds = this.projects.getDataExtent();
      } else {
        this.data.addFeatures(features);
        bounds = this.data.getDataExtent();
      }
      this.fit(bounds, 4);
    }
    if(Ext.Msg.isVisible()) { Ext.Msg.hide(); }
  },

  showAllFeatures: function(pbar) {
    var projects = [],
        data = [],
        total = 0;

    this.project_cluster_strategy.activate();
    this.data_cluster_strategy.activate();

    this.control('select_item').activate();

    this.store.each(function(r) {
      var features = this.buildFeatures(r); //r.get('features');
      
      if(features.length > 0) {
        if(r.get('type') == 'Project') {
          projects = projects.concat(features);
        } else {
          data = data.concat(features);
        }
      }
    }, this);

    this.projects.removeAllFeatures();
    this.data.removeAllFeatures();
    if(projects.length > 0) {this.projects.addFeatures(projects);}
    if(data.length > 0) {this.data.addFeatures(data);}
    
    if(Ext.Msg.isVisible()) { Ext.Msg.hide(); }
    this.fireEvent('featuresrendered', this);
  }
  */
});
