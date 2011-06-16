App.views.add('catalog-map', function(config) {
  var _panel = {
    itemId: 'map',
    region: 'north',
    split: true,
    collapseMode: 'mini',
    height: 400,
    map: 'google',
    hideMapToolHeaders: true,
    xtype: 'openlayers',
    buildSearchFeature: function(wkt, r) {
      if(wkt !== null) {
        var geom = new OpenLayers.Geometry.fromWKT(wkt);
        var point = geom;
//        var point = geom.getCentroid();
        point.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
        return new OpenLayers.Feature.Vector(point, r.data);
      }
      return null;
    },
    loadSearchResults: function(store) {
      this.projects_layer.removeAllFeatures();
      this.data_layer.removeAllFeatures();
      this.search_features.clear();

      store.each(function(r) {
        Ext.each(r.get('locations'), function(loc) {
          var feature = this.buildSearchFeature(loc.wkt, r);

          if(feature !== null) {
            var fid = r.get('fid');
            if(!fid) { fid = []; }
            
            fid.push(feature.id);
            r.set('fid', fid);

            this.search_features.add(feature.id, feature);
          }
        }, this);
      }, this);
      this.showAllFeatures();

    },

    showSelectedFeatures: function(ids) {
      var projects = [];
      var data = [];

      this.projects_layer.removeAllFeatures();
      this.data_layer.removeAllFeatures();
      this.project_cluster_strategy.deactivate();
      this.data_cluster_strategy.deactivate();

      if(ids) {
        this.search_features.each(function(f) {
          if(ids.indexOf(f.id) >= 0) { projects.push(f); }
        }, this);
        this.projects_layer.addFeatures(projects);
        this.data_layer.addFeatures(data);

        var bounds = this.projects_layer.getDataExtent();
        if(bounds) {
          bounds.extend(this.data_layer.getDataExtent());
        } else {
          bounds = this.data_layer.getDataExtent();
        }
        this.fit(bounds, 10);
      }
    },

    showAllFeatures: function() {
      var projects = [];
      var data = [];
      
      this.projects_layer.removeAllFeatures();
      this.data_layer.removeAllFeatures();

      this.project_cluster_strategy.activate();
      this.data_cluster_strategy.activate();

      if(this.search_features.length == 0) {
        return false;
      }

      this.search_features.each(function(f) {
        projects.push(f);
      });

      this.projects_layer.addFeatures(projects);
      this.data_layer.addFeatures(data);

      var bounds = this.projects_layer.getDataExtent();
      if(bounds) {
        bounds.extend(this.data_layer.getDataExtent());
      } else {
        bounds = this.data_layer.getDataExtent();
      }
      this.fit(bounds, 4);
    },
    
    listeners: {
      ready: function(map) {
        map.project_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: 30 });
        map.search_features = new Ext.util.MixedCollection();
        map.projects_layer = new OpenLayers.Layer.Vector('Projects', {
          strategies: [ map.project_cluster_strategy ],
          styleMap: new OpenLayers.StyleMap({
            "default": new OpenLayers.Style({
              label: "${count}",
              fontWeight: 'bold',
              pointRadius: "${radius}",
              fillColor: "#94fbff",
              fillOpacity: 0.5,
              strokeColor: '#0000FF',
              strokeWidth: 2,
              strokeOpacity: 1
            }, {
              context: {
                count: function(feature) {
                  return feature.attributes.count;
                },
                radius: function(feature) {
                  if(feature.attributes.count === undefined) {
                    return 8;
                  } else {
                    return Math.min(Math.floor(feature.attributes.count / 10), 10) + 10;
                  }
                }
              }
            })
          })
        });
        map.addLayer(map.projects_layer);

        map.data_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: 30 });
        map.data_layer = new OpenLayers.Layer.Vector('Data', {
          strategies: [ map.data_cluster_strategy ],
          styleMap: new OpenLayers.StyleMap({
            "default": new OpenLayers.Style({
              label: "${count}",
              fontWeight: 'bold',
              pointRadius: "${radius}",
              fillColor: "#ffcc66",
              fillOpacity: 0.5,
              strokeColor: '#cc6633',
              strokeWidth: 2,
              strokeOpacity: 1
            }, {
              context: {
                count: function(feature) {
                  return feature.attributes.count;
                },
                radius: function(feature) {
                  if(feature.attributes.count === undefined) {
                    return 8;
                  } else {
                    return Math.min(Math.floor(feature.attributes.count / 10), 10) + 10;
                  }
                }
              }
            })
          })
        });
        map.addLayer(map.data_layer);

//        var grid = map.ownerCt.get('grid');
//        if(grid) {
//          grid.getSelectionModel().on('selectionchange', function(sm) {
//            var record = sm.getSelected();
//            if(record) {
//              this.showSelectedFeatures(record.get('fid'));
//            } else {
//              this.showAllFeatures();
//            }
//          }, map);
//        }
        App.store('search_results').on('load', this.loadSearchResults, map);
      }
    }    
  };

  Ext.apply(_panel, config);

  return _panel;
});