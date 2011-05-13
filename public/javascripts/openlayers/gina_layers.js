Ext.ux.GinaMaps = function() {
  var _self = {
    "map": null,
    
    layers: [],

    configs: {
      bdl_aa: {
        name: 'Best Data Layer',
        type: 'tiles',
        baseUrl: 'http://swmha.gina.alaska.edu/tilesrv/bdl_esri_test/tile/',
        wrapDateLine: false
      },
      sdmi_soy_aa: {
        name: 'Soy WMS',
        type: 'wms',
        baseUrl: 'http://wms.soy.gina.alaska.edu/map/test_ortho_rgb',
        params: {
          layers: "SPOT5.SDMI.TEST,SPOT5.SDMI.PILOT",
          transparent: true
        },
        options: {
          wrapDateLine: false,
          isBaseLayer: false
        }
      }
    },

    getUrl: function(bounds) {
      var res = this.map.getResolution();
      var x = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
      var y = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
      var z = this.map.getZoom();
      var tileCount = (1<<z);

      //Wrap the X value
      var X = (x % tileCount);
      //Check for JS modulo operator possibly returning negative values
      if(X < 0) { X += tileCount; }

      var path = X + "/" + y + "/" + z;
      var url = this.url;
      if (url instanceof Array) {
          url = this.selectUrl(path, url);
      }
      return url + path;
    },

    imageMapType: function(name) {
      if(!this.layers[name]) {
        this.layers[name] = new OpenLayers.Layer.TMS(this.configs[name].name, this.configs[name].baseUrl, {
          'type': 'jpeg',
          'getURL': this.getUrl,
          'wrapDateLine': this.configs[name].wrapDateLine
        });
      }

      return this.layers[name];
    },

    wmsMapType: function(name) {
      if(!this.layers[name]) {
        this.layers[name] = new OpenLayers.Layer.WMS(
          this.configs[name].name, this.configs[name].baseUrl, this.configs[name].params, this.configs[name].options
        );
      }

      return this.layers[name];
    },

    init: function(map) {
      this.map = map;
      this.map.addLayer(this.imageMapType('bdl_aa'));
      this.map.addLayer(this.wmsMapType('sdmi_soy_aa'));
    },

    showLabels: function() {
      //this.map.overlayMapTypes.insertAt(0, this.imageMapType('labels'));
    }
  };

  return _self;
};