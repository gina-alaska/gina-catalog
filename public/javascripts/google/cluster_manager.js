ClusterManager = function(config) {
  Ext.apply(this, config);
  
  ClusterManager.superclass.constructor.call(this);

  this.overlay = new ClusterOverlay(this.map);
  this.clusters = [];
  this.markers = [];
  this.currentZoom = null;

  google.maps.event.addListener(this.map, 'idle', this.showVisibleClusters.createDelegate(this));
  //google.maps.event.addListener(this.overlay, 'ready', this.showVisibleClusters.createDelegate(this));
};

Ext.extend(ClusterManager, Ext.util.Observable, {
  getMap: function() {
    return this.map;
  },

  addMarkers: function(markers) {
    Ext.each(markers, function(marker) {
      this.markers.push(marker);
    }, this);
    this.clearClusters();
    this.buildClusters();
    this.showVisibleClusters();
  },

  showVisibleClusters: function() {
    if(this.currentZoom != this.getMap().getZoom()) {
      //remove the currently visible clusters
      this.clearClusters();
      this.buildClusters();
    }

    var bounds = this.getMap().getBounds();
    this.currentZoom = this.map.getZoom();
    Ext.each(this.clusters, function(cluster){
      if(bounds.intersects(cluster.getBounds())) {
        cluster.show();
      }
    }, this);
  },

  buildClusters: function() {
    var index;

    Ext.each(this.markers, function(marker) {
      index = Ext.each(this.clusters, function(cluster) {
        if(cluster.contains(marker)) {
          cluster.addMarker(marker);
          return false;
        }
      }, this);
      
      if(index === null || index === undefined) {
        this.clusters.push(new ClusterGroup(this, marker));
      }
    }, this);
  },

  clearClusters: function() {
    Ext.each(this.clusters, function(cluster) {
      cluster.clearMarkers();
    }, this);
    this.clusters = [];
  },

  clearMarkers: function() {
    this.clearClusters();
    this.markers = [];
  },

  getProjection: function() {
    return this.overlay.getProjection();
  }
});

ClusterGroup = function(manager, marker) {
  ClusterGroup.superclass.constructor.call(this);
  
  this.manager = manager;
  this.markers = [];
  this.center = null;
  this.projection = this.manager.getProjection();
  this.cluster = null;
  this.bounds = null;
  this.markerBounds = null;

  this.addMarker(marker);

  var position = this.projection.fromLatLngToDivPixel(this.center);
  var sw = new google.maps.Point(position.x - this.manager.gridSize, position.y + this.manager.gridSize);
  var ne = new google.maps.Point(position.x + this.manager.gridSize, position.y - this.manager.gridSize);

  this.bounds = new google.maps.LatLngBounds(
    this.projection.fromDivPixelToLatLng(sw),
    this.projection.fromDivPixelToLatLng(ne)
  );

};
Ext.extend(ClusterGroup, Ext.util.Observable, {
  addMarker: function(marker) {
    if(!this.markerBounds) {
      this.markerBounds = new google.maps.LatLngBounds(marker, marker);
    } else {
      this.markerBounds.extend(marker);
    }
    this.center = this.markerBounds.getCenter();

    //marker.setMap(null);

    this.markers.push(marker);
  },
  show: function() {
//    if(this.markers.length == 1) {
//      this.markers[0].setMap(this.manager.getMap());
//    } else if (this.markers.length > 1) {
      /* Hide the marker so we can create our own cluster marker */
      if(!this.clusterMarker) {
        this.clusterMarker = new ClusterMarker(this.manager, this);
      }
      this.clusterMarker.show(); 
//    }
  },
  hide: function() {
//    if(this.markers.length == 1) {
//      this.markers[0].setMap(null);
//    } else if(this.markers.length > 1) {
      try {
        this.clusterMarker.hide();
      } catch(e) {
      }
//    }
  },
  contains: function(position) {
    return this.bounds.contains(position);
  },
  getPosition: function() {
    return this.center;
  },
  getMarkerCount: function() {
    return this.markers.length;
  },
  getBounds: function() {
    return this.bounds;
  },
  clearMarkers: function() {
//    Ext.each(this.markers, function(marker) {
//      marker.setMap(null);
//    }, this);
    this.markers = [];
    if (this.clusterMarker) {
      this.clusterMarker.setMap(null);
    }
  }
});

ClusterMarker = function(manager, cluster) {
  this.manager = manager;
  this.cluster = cluster;
  this.div = null;
  this.position = this.cluster.getPosition();
  this.style = null;

  Ext.each(this.manager.styles, function(style, index) {
    if(style && this.cluster.getMarkerCount() > index) {
      this.style = style;
    }
  }, this);

  google.maps.OverlayView.call(this);
  this.setMap(this.manager.getMap());
};

Ext.extend(ClusterMarker, google.maps.OverlayView, {
  onAdd: function() {
    this.div_ = document.createElement('div');
    this.div_.className = this.style.className;
    if(this.style.url) {
      this.div_.style.background = 'url("' + this.style.url + '") no-repeat';
    }
    if(this.style.backgroundColor) {
      this.div_.style.backgroundColor = this.style.backgroundColor;
    }
    if(this.style.border) {
      this.div_.style.border = this.style.border;
    }
    this.div_.style.color = this.style.textColor;

    // Marker count
    this.div_.style.textAlign = 'center';
    this.div_.style.verticalAlign = 'middle';
    this.div_.style.fontFamily = 'Arial, Helvetica';
    this.div_.style.fontSize = '11px';
    this.div_.style.fontWeight = 'bold';

    // Cursor and onlick
    this.div_.style.cursor = 'pointer';

    this.getPanes().overlayImage.appendChild(this.div_);
  },

  onRemove: function() {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
  },

  draw: function() {
    // Position
    var width, height, zoom = this.map.getZoom();
    var position = this.getProjection().fromLatLngToDivPixel(this.position);
    this.div_.innerHTML = this.cluster.getMarkerCount();

    width = this.style.width;
    height = this.style.height;
    if(this.style.incrementSize) {
      width  += Math.min(30, Math.ceil(this.cluster.getMarkerCount()/15) * zoom * this.style.incrementSize);
      height += Math.min(30, Math.ceil(this.cluster.getMarkerCount()/15) * zoom * this.style.incrementSize);
    }
    this.div_.style.width = width + 'px';
    this.div_.style.height = height + 'px';
    this.div_.style.position = 'absolute';
    this.div_.style.left = (position.x - parseInt(width / 2) - 2) + 'px';
    this.div_.style.top = (position.y - parseInt(height / 2)) + 'px';
    this.div_.style.lineHeight = height + 'px';
    this.div_.style.zIndex = this.style.zIndex;

    if(this.cluster.getMarkerCount() == 1 && this.cluster.markers[0].onClick) {
      google.maps.event.addDomListener(this.div_, 'click', function(e) {
        this.cluster.markers[0].onClick(this.map, this.div_);
      }.createDelegate(this));
    } else {
      google.maps.event.addDomListener(this.div_, 'click', function(e) {
        this.map.fitBounds(this.cluster.getBounds());
      }.createDelegate(this));
    }
  },

  hide: function() {
    this.div_.style.visibility = 'hidden';
  },

  show: function() {
    if(this.div_) {
      this.div_.style.visibility = 'visible';
    }
  }
});

ClusterOverlay = function(map) {
  google.maps.OverlayView.call(this);
  this.setMap(map);
};
Ext.extend(ClusterOverlay, google.maps.OverlayView, {
  draw: function() { if(!this.ready) {
    this.ready = true;
    google.maps.event.trigger(this, 'ready');
  } }
});
