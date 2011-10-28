Ext.define('App.view.catalog.map', {
  alias: 'catalog.map',
  extend: 'Ext.OpenLayers.Panel',

  enableGraticule: false,

  initComponent: function() {
    this.addEvents('featureclick', 'clusterclick', 'aoiadded');
    this.callParent();
  },

  setup: function() {
    this.setupLayers();
    this.setupControls();
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
            return Math.min(Math.floor(feature.attributes.count / 15), 10) + 10;
          }
        }
      }
    };

    this.project_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: 40 });
    this.projects = new OpenLayers.Layer.Vector('Projects', {
      strategies: [ this.project_cluster_strategy ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          // label: "${count}",
          // fontWeight: 'bold',
          pointRadius: "${radius}",
//          pointRadius: 4,
          fillColor: "#94fbff",
          fillOpacity: 0.3,
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

    this.data_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: 40 });
    this.data = new OpenLayers.Layer.Vector('Data', {
      strategies: [ this.data_cluster_strategy ],
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style({
          // label: "${count}",
          // fontWeight: 'bold',
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

  buildSearchFeature: function(wkt, r) {
    if(wkt !== null) {
      var geom = new OpenLayers.Geometry.fromWKT(wkt);
      // var point = geom;
      var point = geom.getCentroid();
      point.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
      return new OpenLayers.Feature.Vector(point, { id: r.data.id, title: r.data.title });
    }
    return null;
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
        features = r.get('features');

    if(features === undefined) {
      features = [];
      Ext.each(r.get('locations'), function(loc) {
        var f = this.buildSearchFeature(loc.wkt, r);
        if(f !== null) { features.push(f); }
      }, this);
      if(features.length > 0) { r.set('features', features); }
    }

    if(r.get('type') == 'Project') {
      this.projects.addFeatures(features);
    } else {
      this.data.addFeatures(features);
    }

    if(features.length > 0) {
      var bounds = this.projects.getDataExtent();
      if(bounds) {
        bounds.extend(this.data.getDataExtent());
      } else {
        bounds = this.data.getDataExtent();
      }
      this.fit(bounds, 4);
    }
    if(Ext.Msg.isVisible()) { Ext.Msg.hide(); }
  },

  showAllFeatures: function(pbar) {
    var projects = [],
        data = [];

    this.projects.removeAllFeatures();
    this.data.removeAllFeatures();

    this.project_cluster_strategy.activate();
    this.data_cluster_strategy.activate();

    this.control('select_item').activate();

    this.store.each(function(r) {
      var rec = r;
      var features = r.get('features');
      
      if(features === undefined || features === '') {
        features = [];
        Ext.each(r.get('locations'), function(loc) {
          var f = this.buildSearchFeature(loc.wkt, r);
          if(f !== null) { features.push(f); }
        }, this);
        if(features.length > 0) { r.set('features', features); }
      }

      if(features.length > 0) {
        if(rec.get('type') == 'Project') {
          projects = projects.concat(features);
        } else {
          data = data.concat(features);
        }
      }
    }, this);

    if(projects.length > 0 || data.length > 0) {
      this.projects.addFeatures(projects);
      this.data.addFeatures(data);
    }
    if(Ext.Msg.isVisible()) { Ext.Msg.hide(); }
  }
});