Ext.ux.GinaMaps = {
  layers: [],

  configs: {
    bdl: {
      name: 'Best Data Layer',
      alt: 'Best Data Layer',
      minZoom: 1,
      maxZoom: 21,
      tileSize: new google.maps.Size(256, 256),
      isPng: true
    },
    labels: {
      name: 'Labels',
      alt: 'Labels',
      minZoom: 1,
      maxZoom: 21,
      tileSize: new google.maps.Size(256, 256),
      isPng: true,
      getTileUrl: function(c, zoom) {
        var tiles = 1 << zoom, X = (c.x % tiles);
        if(X < 0) { X += tiles; }
        var baseUrl = 'http://mt1.google.com/vt/lyrs=h';
        return baseUrl + '&x=' + X + '&y=' + c.y + '&z=' + zoom;
      }
    }
  },
  
  getUrl: function(a, z) {
    var tiles = 1 << z, X = (a.x % tiles);
    if(X < 0) { X += tiles; }
    return baseUrl + X + '/' + a.y + '/' + z + '.png';
  },

  imageMapType: function(name) {
    if(!this.layers[name]) {
      Ext.applyIf(this.configs[name], {
        getTileUrl: function(a, z) {
          var tiles = 1 << z, X = (a.x % tiles);
          if(X < 0) { X += tiles; }
          
          var baseUrl='http://swmha.gina.alaska.edu/tilesrv/' + name + '/tile/';
          return baseUrl + X + '/' + a.y + '/' + z + '.png';
        }
      });
      
      this.layers[name] = new google.maps.ImageMapType(this.configs[name]);
    }

    return this.layers[name];
  },

  init: function(map) {
    this.map = map;
    this.map.mapTypes.set('BDL', this.imageMapType('bdl'));
  },

  showLabels: function() {
    this.map.overlayMapTypes.insertAt(0, this.imageMapType('labels'));
  }
}