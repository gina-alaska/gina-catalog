Ext.ux.GMapPanel = Ext.extend(Ext.Panel, {
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
   *  Google Map Object
   */
  map: {
    zoom: 4,
    center: new google.maps.LatLng(64.8600, -147.8492),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  },

  /**
   * private
   */
  initComponent: function() {
    this.addEvents('ready', 'mapmove', 'mousemove');

    Ext.apply(this, {
      bbar: ['->', {
        itemId: 'center_location',
        xtype: 'component',
        html: 'Center: ()'
      }, '-', {
        itemId: 'mouse_location',
        xtype: 'component',
        html: 'Mouse: ()'
      }]
    });

    Ext.apply(this.map, this.mapConfig);

    Ext.ux.GMapPanel.superclass.initComponent.call(this);

    this.on('render', this.initGMap, this);
    this.on('ready', this.onMapMove, this);
    this.on('resize', this.resizeMap, this);
  },

  /**
   * private
   */
  initGMap: function() {
    this.map = new google.maps.Map(this.body.dom, this.map);

    if(this.trackMouseMovement) {
      google.maps.event.addListener(this.map, 'mousemove', this.onMouseMove.createDelegate(this));
    }
    if(this.trackMapMovement) {
      google.maps.event.addListener(this.map, 'center_changed', this.onMapMove.createDelegate(this));
    }
    
    this.mapReady = true;

    /* Give the google map some time to finish loading */
    this.fireEvent.defer(300, this, ['ready', this]);
  },
  
  /**
   * Returns the google map object if it has been initialized, false otherwise
   */
  getMap: function() {
    if(this.mapReady) {
      return this.map;
    }
    return false;
  },

  onMouseMove: function(e) {
    var lat = Ext.util.Format.number(e.latLng.lat(), '0.0000'),
        lng = Ext.util.Format.number(e.latLng.lng(), '0.0000'),
        bbar = this.getBottomToolbar(),
        el = bbar.get('mouse_location');
    el.update('Mouse (' + lat + ', ' + lng + ')')

    this.fireEvent('mousemove', this, e);
  },
  
  onMapMove: function() {
    this.center = this.getMap().getCenter();
    var center = this.getMap().getCenter(),
        lat = Ext.util.Format.number(center.lat(), '0.0000'),
        lng = Ext.util.Format.number(center.lng(), '0.0000'),
        bbar = this.getBottomToolbar(),
        el = bbar.get('center_location');
    el.update('Center (' + lat + ', ' + lng + ')')

    this.fireEvent('mapmove', this, this.center);
  },

  resizeMap: function() {
    if (this.mapReady) {
      var center = this.getMap().getCenter();
      google.maps.event.trigger(this.getMap(), 'resize');
      this.getMap().setCenter(center);
    } else {
      this.on('ready', this.resizeMap, this, { single: true });
    }
  },

  showLayer: function(layer) {
    this.getMap().setMapTypeId(layer);
  },

  addGeom: function(geom) {
    geom.setMap(this.getMap());
  },

  panToBounds: function(bounds) {
    this.getMap().panToBounds(bounds);
  },

  fit: function(bounds) {
    this.getMap().fitBounds(bounds);
  },

  /**
   * Stuff for gina layers
   */
  addGinaLayers: function() {
    Ext.ux.GinaMaps.init(this.getMap());
  },

  showLabels: function() {
    Ext.ux.GinaMaps.showLabels();
  }
});
Ext.reg('gmap', Ext.ux.GMapPanel);