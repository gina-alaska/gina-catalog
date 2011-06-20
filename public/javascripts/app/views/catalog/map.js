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
      //this.showAllFeatures();
      this.control('select_item').activate();
    },

    showSelectedFeature: function(id, pbar) {
      var projects = [];
      var data = [];

      this.projects_layer.removeAllFeatures();
      this.data_layer.removeAllFeatures();

      this.project_cluster_strategy.deactivate();
      this.data_cluster_strategy.deactivate();
      this.control('select_item').deactivate();

      var r = App.store('search_results').getById(id);

      Ext.ux.each(r.get('locations'), {
        exclusive: true,
        scope: this,
        progress: pbar,
        handler: function(loc) {
          var feature = this.search_features.get(loc.id);
          if(feature === undefined) {
            feature = this.buildSearchFeature(loc.wkt, r);
            this.search_features.add(loc.id, feature);
          }
          if(feature !== null) { projects.push(feature); }
        },
        onComplete: function() {
          if(projects.length > 0 || data.length > 0) {
            this.projects_layer.addFeatures(projects);
            this.data_layer.addFeatures(data);

            var bounds = this.projects_layer.getDataExtent();
            if(bounds) {
              bounds.extend(this.data_layer.getDataExtent());
            } else {
              bounds = this.data_layer.getDataExtent();
            }
            this.fit(bounds, 4);
          }
        }
      });
    },

    taskrunner: new Ext.util.TaskRunner(0.00000000001),

    showAllFeatures: function(pbar) {
      var total = App.store('search_results').getCount(),
          current = 0,
          percent = 0,
          lastPercent = 0,
          projects = [],
          data = [];

      this.projects_layer.removeAllFeatures();
      this.data_layer.removeAllFeatures();

      this.project_cluster_strategy.activate();
      this.data_cluster_strategy.activate();

      this.control('select_item').activate();


      App.store('search_results').each(function(r) {
        Ext.each(r.get('locations'), function(loc) {
          var feature = this.search_features.get(loc.id);
          if(feature === undefined) {
            feature = this.buildSearchFeature(loc.wkt, r);
            this.search_features.add(loc.id, feature);
          }
          if(feature !== null) {
            projects.push(feature);
          }
        }, this);
      }, this);

      if(projects.length > 0 || data.length > 0) {
        this.projects_layer.addFeatures(projects);
        this.data_layer.addFeatures(data);
      }
      if(pbar) { pbar.hide(); }
    },
    
    listeners: {
      ready: function(map) {
        map.project_cluster_strategy = new OpenLayers.Strategy.Cluster({ distance: 30 });
        map.search_features = new Ext.util.MixedCollection();

        var styleFunctions = {
          context: {
            count: function(feature) {
              if(feature.attributes.title) {
                return '';
              } else {
                return feature.attributes.count;
              }
            },
            radius: function(feature) {
              if(feature.attributes.count === undefined) {
                return 8;
              } else {
                return Math.min(Math.floor(feature.attributes.count / 10), 10) + 10;
              }
            }
          }
        };

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
            }, styleFunctions),
            "select": new OpenLayers.StyleMap({
              fillColor: "#F00",
              strokeColor: '#F00'
            })
          }),
          rendererOptions: { zIndexing: true }
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
            }, styleFunctions),
            "select": new OpenLayers.StyleMap({
              fillColor: "#F00",
              strokeColor: '#F00'
            })
          }),
          rendererOptions: { zIndexing: true }
        });
        map.addLayer(map.data_layer);

        map.controls.add('select_item', new OpenLayers.Control.SelectFeature(map.projects_layer, {
          clickout: true,
          onSelect: function(feature) {
            var pbar = Ext.Msg.show({
              title: 'Please wait...',
              msg: 'Selecting records that include this location',
              minWidth: 300,
              wait: true,
              modal: false
            });

            var filterFunc = function(record, id) {
              var found = Ext.each(feature.cluster, function(item) {
                if(record.get('id') == item.attributes.id) { return false; }
              }, this);

              if(found >= 0) { return true; }
            };

            App.store('search_results').filterBy.defer(100, App.store('search_results'), [filterFunc, this]);
          }.createDelegate(map)
        }));
        map.control('select_item').activate();

        App.store('search_results').on('datachanged', function(store) {
          //this.loadSearchResults(store);
          var pbar = Ext.Msg.show({
            title: 'Please wait...',
            msg: 'Loading records...',
            minWidth: 300,
            wait: true,
            modal: false
          });

          this.showAllFeatures.defer(300, map, [pbar])
        }, map);
      }
    }    
  };

  Ext.apply(_panel, config);

  return _panel;
});