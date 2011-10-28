Ext.define('Ext.OpenLayers.Panel', {
  alias: 'widget.openlayers',
  extend: 'Ext.panel.Panel',

  /**
   * Indicates if the map has been initialized by the panel
   */
  mapReady: false,

  /**
   * Track the mouse movements, defaults to true.
   */
  trackMouseMovement: true,

  /**
   * Track the map movements, defaults to true,
   */
  trackMapMovement: true,

  /**
   * Show lat/lon lines and labels on the map
   */
  enableGraticule: true,

  hideMapToolHeaders: false,

  mapToolbar: {
    "Layers": ['layers'],
    "Zoom": ['zoomIn', 'zoomOut'],
    "AOI": ['aoi'],
    "Pan": ['pan']
  },
  mapTools: {},

  config: {
    projection: 'EPSG:3338'
  },

  mapConfigs: {
    'EPSG:3572': {
      defaultCenter: new OpenLayers.LonLat(-147.849, 64.856),
      defaultZoom: 3,
      defaultLayers: ['bdl_3572', 'armap_relief_3572', 'landownership', 'cavm_veg_3572','osm_overlay_3572'], //,'armap_cities_3572'
      maxExtent: new OpenLayers.Bounds(-12742200.0, -7295308.34278405, 7295308.34278405, 12742200.0),
      zoomLevels: 18,
      maxResolution: (20037508.34278405 / 256.0),
      units: 'm',
      projection: "EPSG:3572",
      displayProjection: new OpenLayers.Projection("EPSG:4326")
    },
    'EPSG:3338': {
      defaultCenter: new OpenLayers.LonLat(-147.849, 64.856),
      defaultZoom: 2,
      defaultLayers: ['bdl_aa', 'osm_overlay_3338'],
      maxExtent: new OpenLayers.Bounds(-3500000, -3500000, 3500000, 3500000),
      zoomLevels: 18,
      maxResolution: (3500000 * 2.0 / 256.0),
      units: 'm',
      projection: "EPSG:3338",
      displayProjection: new OpenLayers.Projection("EPSG:4326")
    },
    'google': {
      defaultCenter: new OpenLayers.LonLat(-147.849, 64.856),
      defaultZoom: 3,
      zoomLevels: 18,
      defaultLayers: ['bdl', 'charts', 'topo', 'shaded_relief', 'landsat_pan'],
      projection: "EPSG:900913",
      units: 'm',
      maxResolution: 156543.0339,
      maxExtent: new OpenLayers.Bounds(-20037508, -20037508, 20037508, 20037508),
      displayProjection: new OpenLayers.Projection("EPSG:4326")
    }
  },

  controls: null,

  control: function(key) {
    return this.controls.get(key);
  },

  constructor: function(config) {
    this.initConfig(config);
    
    this.controls = new Ext.util.MixedCollection(true);
    this.layersMenu = new Ext.menu.Menu();
    this.callParent(arguments);
  },

  /**
   * private
   */
  initComponent: function() {    
    this.addEvents('ready', 'mapmove', 'mousemove', 'aoiadded');

    this.loadIndicator = new Ext.toolbar.Item({
      height: 16,
      html: '<div style="padding-top: 2px;">Loading....</div>',
      cls: 'loading-indicator'
    });

    this.mapConfig = {};
    Ext.apply(this.mapConfig, this.mapConfigs[this.getProjection()]);

    this.callParent(arguments);

    this.initToolbars();
        
    this.on('afterrender', this.initMap, this);
    this.on('resize', this.resizeMap, this);
    this.on('ready', function() { this.isReady = true; }, this);
  },

  initToolbars: function() {
    if(this.fbar !== false) {
      this.bottomToolbar = Ext.create('Ext.toolbar.Toolbar', {
        dock: 'bottom'
      });
      this.bottomToolbar.add(
        Ext.create('Ext.form.FormPanel', {
          border: false,
          bodyStyle: 'background: none;',
          defaultType: 'textfield',
          items: [{
            labelWidth: 25,
            width: 100,
            fieldLabel: 'Lat',
            name: 'lat'
          },{
            labelWidth: 25,
            width: 100,
            fieldLabel: 'Lon',
            name: 'lng'
          }, {
            xtype: 'button',
            text: 'Go',
            scope: this,
            handler: function(but) {
              this.panToCoords(but.up('form').getValues());
            }
          }]
        }),
        this.loadIndicator, '&nbsp;',
        '->',
        Ext.create('Ext.toolbar.Item', {
          itemId: 'center_location',
          cls: 'map-indicator',
          width: 150,
          tpl: new Ext.Template('<div style="">Center: ({lat},{lng})</div>'),
          html: 'Center: ()'
        }), '-',
        Ext.create('Ext.toolbar.Item', {
          itemId: 'mouse_location',
          cls: 'map-indicator',
          width: 150,
          tpl: new Ext.Template('<div style="">Mouse: ({lat},{lng})</div>'),
          html: 'Mouse: ()'
        })
      );
      this.addDocked(this.bottomToolbar);
    }
  },

  getBottomToolbar: function() {
    return this.bottomToolbar;
  },

  aoiHandler: function(state) {
    if(state) {
      this.selectionLayer.removeAllFeatures();
      this.control('aoi').activate();
    } else {
      this.control('aoi').deactivate();
    }
  },

  /**
   * private
   */
  initMap: function() {
    this.map = new OpenLayers.Map(this.body.dom, this.mapConfig);
    // this.setupLayerMenu();
    this.addGinaLayers();

    var center = this.mapConfig.defaultCenter.clone();
    center.transform(this.map.displayProjection, this.map.getProjectionObject());
    this.map.setCenter(center, this.mapConfig.defaultZoom);
    
    this.controls.on('add', function(index, obj, key) {
      this.getMap().addControl(obj);
    }, this);
    this.controls.on('remove', function(obj, key) {
      obj.deactivate();
      this.getMap().removeControl(obj);
    }, this);
    
    this.controls.add('layers', new OpenLayers.Control.LayerSwitcher({
      title: 'Layers: Click here to expand the layer selection list'
    }));

    this.dragPanControl = new OpenLayers.Control.DragPan({
      title: 'Pan Map: Click and drag on the map to pan',
      documentDrag: true,
      enableKinetic: true
    });
    this.zoomInBoxControl = new OpenLayers.Control.ZoomBox({
      title: 'Zoom In: Click/Drag the the mouse on the map to zoom in',
      displayClass: 'zoomInBox'
    });
    this.zoomOutBoxControl = new OpenLayers.Control.ZoomBox({ 
      out: true,
      title: 'Zoom Out: Click/Drag the the mouse on the map to zoom out',
      displayClass: 'zoomOutBox'
    });

    this.map.addControls([this.dragPanControl, this.zoomInBoxControl, this.zoomOutBoxControl]);
    this.dragPanControl.activate();

    if(this.enableGraticule !== false) {
      this.controls.add('graticule', new OpenLayers.Control.Graticule({
        labelFormat: 'dm',
        lineSymbolizer: {
          strokeColor: '#00FF00',
          strokeOpacity: 0.7,
          strokeWidth:1,
          strokeLinecap: 'round'
        },
        labelSymbolizer: {
          fontColor: '#FFFF00',
          fontOpacity: 1
        }
      }));
    }

    this.selectionLayer = new OpenLayers.Layer.Vector('Selection', {
      displayInLayerSwitcher: false,
      eventListeners: {
        beforefeaturesadded: function() {
          this.removeAllFeatures();
        }
      }
    });
    this.addLayer(this.selectionLayer);
    
    this.controls.add('aoi', new OpenLayers.Control.DrawFeature(
      this.selectionLayer,
      OpenLayers.Handler.RegularPolygon, {
        title: 'AOI: Click and drag the mouse to define your area of interest',
        handlerOptions: {
          irregular: true
        },
        eventListeners: {
          featureadded: Ext.bind(this.onAoiAdd, this)
        }
      }
    ));
    // this.control('aoi').events.register('featureadded', this, this.onAoiAdd)

    if(this.getBottomToolbar()) {
      this.map.events.register('moveend', this, this.onMapMove);
      this.map.events.register('mousemove', this, this.onMouseMove);
    }

    this.controls.add('attribution', new OpenLayers.Control.Attribution({seperator: ','}));

    /* Give the map some time to finish loading */
    Ext.defer(this.fireEvent, 300, this, ['ready', this]);
  },

  loadingCount: 0,

  onAoiAdd: function(e) {
    this.dragPanControl.activate();
    this.control('aoi').deactivate();
    this.fireEvent('aoiadded', this, e.feature, e);
    // this.mapTools.pan.each(function(button) { button.toggle(true); });
  },

  setupLayerMenu: function() {
    this.getMap().events.register('addlayer', this, this.buildLayerMenu);
    this.getMap().events.register('changebaselayer', this, this.updateLayerMenu);
    this.getMap().events.register('changelayer', this, this.updateLayerMenu);
    this.getMap().events.register('removelayer', this, this.buildLayerMenu);
    this.getMap().events.register('addlayer', this, this.addLayerMonitor);
    this.buildLayerMenu();
  },

  addLayerMonitor: function(e) {
    e.layer.events.register('loadstart', this, 
      Ext.bind(this.monitorLayer, this, [e.layer, 'start'])
    );
    e.layer.events.register('loadend', this, 
      Ext.bind(this.monitorLayer, this, [e.layer, 'end'])
    );
  },

  monitorLayer: function(layer, type) {
    if(type == 'start') {
      this.loadingCount += 1;
    } else {
      this.loadingCount -= 1;
    }
    if(this.loadingCount >= 1) {
      this.loadIndicator.show();
    } else {
      this.loadingCount = 0;
      this.loadIndicator.hide();
    }
  },

  buildLayerMenu: function() {
    var base = [], overlay = [];
    Ext.each(this.getMap().layers, function(item) {
      if(!item.displayInLayerSwitcher) { return; }

      if(item.isBaseLayer) {
        if(item.getVisibility()) { this.activeBaseLayer = item; }

        base.push({
          text: item.name,
          layer: item,
          group: this.id + '_baselayer',
          xtype: 'menucheckitem',
          checked: item.getVisibility(),
          scope: this,
          checkHandler: this.baseMenuHandler
        });
      } else {
        overlay.push({
          text: item.name,
          layer: item,
          xtype: 'menucheckitem',
          checked: item.getVisibility(),
          hideOnClick: false,
          scope: this,
          checkHandler: this.overlayMenuHandler
        });
      }
    }, this);

    // this.layersMenu.removeAll();
    // this.layersMenu.add('<b>Base Layer</b>', base, '-', '<b>Overlays</b>', overlay);
  },

  updateLayerMenu: function() {
    this.layersMenu.items.each(function(item) {
      if(item.layer) {
        if(item.layer.isBaseLayer && item.layer.getVisibility()) {
          this.activeBaseLayer = item.layer;
        }
        item.setChecked(item.layer.getVisibility());
      }
    }, this);
    return true;
  },

  baseMenuHandler: function(menu, checked) {
    if(checked) {
      this.getMap().setBaseLayer(menu.layer);
    }
  },

  overlayMenuHandler: function(menu, checked) {
    if(checked) {
      menu.layer.setVisibility(true);
    } else {
      menu.layer.setVisibility(false);
    }
  },

  /**
   * Returns the google map object if it has been initialized, false otherwise
   */
  getMap: function() {
    return this.map;
  },

  onMouseMove: function(e) {
    var bbar = this.getBottomToolbar();

    if(bbar) {
      var lon, lat, pixel = new OpenLayers.Pixel(e.layerX, e.layerY),
          el = bbar.getComponent('mouse_location');

      var point = this.getMap().getLonLatFromPixel(pixel);

      if(this.getMap().displayProjection) {
        point.transform(this.getMap().getProjectionObject(), this.getMap().displayProjection);
      }

      // lat = Ext.util.Format.number(point.lat, '0.000');
      // lng = Ext.util.Format.number(point.lon, '0.000');

      el.update(el.tpl.apply({ "lat": point.lat, "lng": point.lng }));
    }

    this.fireEvent('mousemove', this, e);
  },

  onMapMove: function(e) {
    if(e.type == 'moveend') {
      var bbar = this.getBottomToolbar();
      this.center = this.getMap().getCenter();
      if(this.getMap().displayProjection) {
        this.center.transform(this.getMap().getProjectionObject(), this.getMap().displayProjection);
      }

      if(bbar) {
        var lat = Ext.util.Format.number(this.center.lat, '0.000'),
            lng = Ext.util.Format.number(this.center.lon, '0.000'),
            el = bbar.getComponent('center_location');
        el.update(el.tpl.apply({ "lat": lat, "lng": lng }));
      }

      this.fireEvent('mapmove', this, this.center);
    }
  },

  resizeMap: function() {
    if (this.isReady) {
      var center = this.getMap().getCenter();
      this.getMap().updateSize();
      this.getMap().setCenter(center);
      this.getActiveBaseLayer().redraw();
    } else {
      this.on('ready', this.resizeMap, this, { single: true });
    }
  },

  getActiveBaseLayer: function() {
    var layers = this.getMap().getLayersBy('visibility', true);
    var base;
    
    Ext.each(layers, function(layer) {
      if(layer.isBaseLayer) {
        base = layer;
        return false;
      }
    }, this);
    return base;
  },

  showLayer: function(layer) {
    //this.getMap().setMapTypeId(layer);
  },

  addGeom: function(geom) {
    geom.setMap(this.getMap());
  },

  panToCoords: function(coords) {
    var loc = new OpenLayers.LonLat(coords.lng, coords.lat);
    loc.transform(this.getMap().displayProjection, this.getMap().getProjectionObject());
    this.getMap().panTo(loc);
  },

  panToBounds: function(bounds) {
    this.getMap().panTo(bounds.getCenterLonLat());
  },

  fit: function(bounds, minZoom) {
    if(minZoom === undefined || minZoom === null) {
      minZoom = 15;
    }
    var zoom = this.getMap().getZoomForExtent(bounds);
    this.panToBounds(bounds);
    //if(zoom > 8) { zoom -= 1; }
    this.getMap().zoomTo(Math.min(zoom, minZoom));
  },

  addLayer: function(layer) {
    return this.getMap().addLayer(layer);
  },

  getCenter: function() {
    return this.getMap().getCenter();
  },

  /**
   * Stuff for gina layers
   */
  addGinaLayers: function() {
    this.gina = Ext.create('Ext.OpenLayers.Layers');
    this.gina.init(this.getMap());
    Ext.each(this.mapConfig.defaultLayers, function(name) {
      this.getMap().addLayer(this.gina.getLayer(name));
    }, this);
  },

  showLabels: function() {
    Ext.ux.GinaMaps.showLabels();
  }
});
