Ext.ux.OpenLayersPanel = Ext.extend(Ext.Panel, {
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

  center: new OpenLayers.LonLat(291180.0443, 1668966.1247),
  zoom: 2,

  /**
   * Defaults to an Alaskan Albers map configuration
   */
  mapConfig: {
    
  },

  map: {
    maxExtent: new OpenLayers.Bounds(-3500000, -3500000, 3500000, 3500000),
    zoomLevels: 18,
    maxResolution: (3500000 * 2.0 / 256.0),
    units: 'm',
    projection: "EPSG:3338",
    displayProjection: new OpenLayers.Projection("EPSG:4326")
  },

  controls: new Ext.util.MixedCollection(true),
  control: function(key) {
    return this.controls.get(key);
  },

  addMapTools: function(title, tools) {
    this.getTopToolbar().add(new Ext.ButtonGroup({
      "title": title,
      "defaults": { iconAlign: 'top', scale: 'medium', minWidth: 60 },
      items: tools
    }));
    
    if(this.getTopToolbar().rendered) {
      this.getTopToolbar().doLayout();
    }
  },

  /**
   * private
   */
  initComponent: function() {
    this.addEvents('ready', 'mapmove', 'mousemove');
//
//    this.maptools = new Ext.ButtonGroup({
//      border: false,
//      title: 'Zoom',
//      defaults: { iconAlign: 'top', scale: 'medium', minWidth: 60 },
//      items:
//    });

    this.layersMenu = new Ext.menu.Menu();
    
    this.loadIndicator = new Ext.Toolbar.Item({
      height: 16, html: '<div style="padding-top: 2px;">Loading....</div>', cls: 'loading-indicator'
    });

    Ext.apply(this, {
      tbar: [],
      bbar: [this.loadIndicator, '->', new Ext.Toolbar.Item({
        itemId: 'center_location',
        cls: 'map-indicator',
        tpl: new Ext.Template('<div style="">Center: ({lat},{lng})</div>'),
        html: 'Center: ()'
      }), '-', new Ext.Toolbar.Item({
        itemId: 'mouse_location',
        cls: 'map-indicator',
        tpl: new Ext.Template('<div style="">Mouse: ({lat},{lng})</div>'),
        html: 'Mouse: ()'
      })]
    });

    Ext.applyIf(this.mapConfig, this.map);
    Ext.applyIf(this.mapConfig, {
      eventListeners: {
        moveend: this.onMapMove.createDelegate(this),
        mousemove: this.onMouseMove.createDelegate(this)
      }
    })

    Ext.ux.OpenLayersPanel.superclass.initComponent.call(this);

    this.mapToolsGroupID = this.id + '-maptools';

    this.addMapTools('Layers', [{
      iconAlign: 'top',
      tooltip: 'Select visible map layers',
      icon: '/images/icons/geo/layers.png',
      menu: this.layersMenu
    }]);

    this.addMapTools('Zoom', [{
      icon: 'images/icons/geo/magnifier_zoom_in.png',
      scope: this,
      tooltip: 'Click/Drag the the mouse on the map to zoom in',
      enableToggle: true, toggleGroup: this.mapToolsGroupID,
      toggleHandler: function(button, state) {
        if(state) {
          this.zoomInBoxControl.activate();
        } else {
          this.zoomInBoxControl.deactivate();
        }
      }
    },{
      icon: 'images/icons/geo/magnifier_zoom_out.png',
      scope: this,
      tooltip: 'Click the map to zoom out',
      enableToggle: true, toggleGroup: this.mapToolsGroupID,
      toggleHandler: function(button, state) {
        if(state) {
          this.zoomOutBoxControl.activate();
        } else {
          this.zoomOutBoxControl.deactivate();
        }
      }
    }]);

    this.on('afterrender', this.initMap, this);
    this.on('resize', this.resizeMap, this);
  },

  /**
   * private
   */
  initMap: function() {
    this.map = new OpenLayers.Map(this.body.dom, this.mapConfig);
    this.setupLayerMenu();

    this.addGinaLayers();
    this.map.setCenter(this.center, this.zoom);

    this.controls.on('add', function(index, obj, key) {
      this.getMap().addControl(obj);
    }, this);
    this.controls.on('remove', function(obj, key) {
      obj.deactivate();
      this.getMap().removeControl(obj);
    }, this);

    this.dragPanControl = new OpenLayers.Control.DragPan({
      documentDrag: true,
      enableKinetic: true
    });
    this.zoomInBoxControl = new OpenLayers.Control.ZoomBox();
    this.zoomOutBoxControl = new OpenLayers.Control.ZoomBox({ out: true });

    this.map.addControls([this.dragPanControl, this.zoomInBoxControl, this.zoomOutBoxControl]);
    this.dragPanControl.activate();

    this.mapReady = true;

    /* Give the map some time to finish loading */
    this.fireEvent.defer(300, this, ['ready', this]);
  },

  loadingCount: 0,

  setupLayerMenu: function() {
    this.getMap().events.register('addlayer', this, this.buildLayerMenu);
    this.getMap().events.register('changebaselayer', this, this.updateLayerMenu);
    this.getMap().events.register('changelayer', this, this.updateLayerMenu);
    this.getMap().events.register('removelayer', this, this.buildLayerMenu);
    this.getMap().events.register('addlayer', this, this.addLayerMonitor);
    this.buildLayerMenu();
  },

  addLayerMonitor: function(e) {
    e.layer.events.register('loadstart', this, this.monitorLayer.createDelegate(this, [e.layer, 'start']))
    e.layer.events.register('loadend', this, this.monitorLayer.createDelegate(this, [e.layer, 'end']))
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
      if(item.isBaseLayer) {
        base.push({
          text: item.name,
          layer: item,
          group: this.id + '_baselayer',
          xtype: 'menucheckitem',
          checked: item.getVisibility(),
          checkHandler: this.layerMenuHandler
        });
      } else {
        overlay.push({
          text: item.name,
          layer: item,
          xtype: 'menucheckitem',
          checked: item.getVisibility(),
          hideOnClick: false,
          checkHandler: this.layerMenuHandler
        });
      }
    }, this);

    this.layersMenu.removeAll();
    this.layersMenu.add('<b>Base Layer</b>', base, '-', '<b>Overlays</b>', overlay);
  },

  updateLayerMenu: function() {
    this.layersMenu.items.each(function(item) {
      if(item.layer) {
        item.setChecked(item.layer.getVisibility());
      }
    }, this);
    return true;
  },

  layerMenuHandler: function(menu, checked) {
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
    var pixel = new OpenLayers.Pixel(e.x, e.y),
        lonLat = this.getMap().getLonLatFromPixel(pixel).transform(
                    this.getMap().getProjectionObject(),
                    this.getMap().displayProjection),
        lat = Ext.util.Format.number(lonLat.lat, '0.0000'),
        lng = Ext.util.Format.number(lonLat.lon, '0.0000'),
        bbar = this.getBottomToolbar(),
        el = bbar.get('mouse_location');
    el.update(el.tpl.apply({ "lat": lat, "lng": lng }))

    this.fireEvent('mousemove', this, e);
  },
  
  onMapMove: function(e) {
    if(e.type == 'moveend'){
      this.center = this.getMap().getCenter();
      this.center.transform(this.getMap().getProjectionObject(), this.getMap().displayProjection);
      
      var lat = Ext.util.Format.number(this.center.lat, '0.0000'),
          lng = Ext.util.Format.number(this.center.lon, '0.0000'),
          bbar = this.getBottomToolbar(),
          el = bbar.get('center_location');
      el.update(el.tpl.apply({ "lat": lat, "lng": lng }));

      this.fireEvent('mapmove', this, this.center);
    }
  },

  resizeMap: function() {
    if (this.mapReady) {
      var center = this.getMap().getCenter();
      this.getMap().updateSize();
      this.getMap().setCenter(center);
    } else {
      this.on('ready', this.resizeMap, this, { single: true });
    }
  },

  showLayer: function(layer) {
    //this.getMap().setMapTypeId(layer);
  },

  addGeom: function(geom) {
    geom.setMap(this.getMap());
  },

  panToBounds: function(bounds) {
    this.getMap().panTo(bounds.getCenterLonLat());
  },

  fit: function(bounds) {
    var zoom = this.getMap().getZoomForExtent(bounds);
    this.panToBounds(bounds);
    //if(zoom > 8) { zoom -= 1; }
    this.getMap().zoomTo(zoom);
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
    this.gina = new Ext.ux.GinaMaps();
    this.gina.init(this.getMap());
  },

  showLabels: function() {
    Ext.ux.GinaMaps.showLabels();
  }
});
Ext.reg('openlayers', Ext.ux.OpenLayersPanel);