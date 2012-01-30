OpenLayers.Util.extend(OpenLayers.Lang.en,
   {
       'SOSClientType': "Type",
       'SOSClientTime': "Date/time",
       'SOSClientLastvalue': "Last value"
   }
);

// Example class on how to put all the OpenLayers SOS pieces together
OpenLayers.SOSClient = OpenLayers.Class({
   url: null,
   map: null,
   capsformat: new OpenLayers.Format.SOSCapabilities(),
   obsformat: new OpenLayers.Format.SOSGetObservation(),
   initialize: function (options) {
       OpenLayers.Util.extend(this, options);
       var params = {'service': 'SOS', 'request': 'GetCapabilities'};
       var paramString = OpenLayers.Util.getParameterString(params);
       url = OpenLayers.Util.urlAppend(this.url, paramString);
       OpenLayers.Request.GET({url: url,
           success: this.parseSOSCaps, scope: this});
   },
   getFois: function() {
       var result = [];
       this.offeringCount = 0; 
       for (var name in this.SOSCapabilities.contents.offeringList) {
           var offering = this.SOSCapabilities.contents.offeringList[name];
           this.offeringCount++;
           for (var i=0, len=offering.featureOfInterestIds.length; i<len; i++) {
               var foi = offering.featureOfInterestIds[i];
               if (OpenLayers.Util.indexOf(result, foi) === -1) {
                   result.push(foi);
               }
           }
       }
       return result;
   },
   parseSOSCaps: function(response) {
       // cache capabilities for future use
       this.SOSCapabilities = this.capsformat.read(response.responseXML || response.responseText);
       this.layer = new OpenLayers.Layer.Vector("Stations", {
           strategies: [new OpenLayers.Strategy.Fixed()],
           protocol: new OpenLayers.Protocol.SOS({
               formatOptions: {internalProjection: this.map.getProjectionObject()},
               url: this.url,
               fois: this.getFois()
           })
       });
       this.map.addLayer(this.layer);
       this.ctrl = new OpenLayers.Control.SelectFeature(this.layer,
           {scope: this, onSelect: this.onFeatureSelect});
       this.map.addControl(this.ctrl);
       this.ctrl.activate();
   },
   getTitleForObservedProperty: function(property) {
       for (var name in this.SOSCapabilities.contents.offeringList) {
           var offering = this.SOSCapabilities.contents.offeringList[name];
           if (offering.observedProperties[0] === property) {
               return offering.name;
           }
       }
   },
   showPopup: function(response) {
       this.count++;
       var output = this.obsformat.read(response.responseXML || response.responseText);
       if (output.measurements.length > 0) {
           this.html += '<tr>';
           this.html += '<td width="100">'+this.getTitleForObservedProperty(output.measurements[0].observedProperty)+'</td>';
           this.html += '<td>'+output.measurements[0].samplingTime.timeInstant.timePosition+'</td>';
           this.html += '<td>'+output.measurements[0].result.value + ' ' + output.measurements[0].result.uom + '</td>';
           this.html += '</tr>';
       }
       // check if we are done
       if (this.count === this.numRequests) {
           var html = '<table cellspacing="10"><tbody>';
           html += '<tr>';
           html += '<th><b>'+OpenLayers.i18n('SOSClientType')+'</b></th>';
           html += '<th><b>'+OpenLayers.i18n('SOSClientTime')+'</b></th>';
           html += '<th><b>'+OpenLayers.i18n('SOSClientLastvalue')+'</b></th>';
            html += '</tr>';
            html += this.html;
            html += '</tbody></table>';
            var popup = new OpenLayers.Popup.FramedCloud("sensor",
            this.feature.geometry.getBounds().getCenterLonLat(),
                null,
                html,
                null,
                true,
                function(e) {
                    this.hide();
                    OpenLayers.Event.stop(e);
                    // unselect so popup can be shown again
                    this.map.getControlsByClass('OpenLayers.Control.SelectFeature')[0].unselectAll();
                } 
            );
            this.feature.popup = popup;
            this.map.addPopup(popup);
        }
    },
    onFeatureSelect: function(feature) {
        this.feature = feature;
        this.count = 0;
        this.html = '';
        this.numRequests = this.offeringCount;
        if (!this.responseFormat) {
            for (format in this.SOSCapabilities.operationsMetadata.GetObservation.parameters.responseFormat.allowedValues) {
                // look for a text/xml type of format
                if (format.indexOf('text/xml') >= 0) {
                    this.responseFormat = format;
                }
            }
        }
        // do a GetObservation request to get the latest values
        for (var name in this.SOSCapabilities.contents.offeringList) {
            var offering = this.SOSCapabilities.contents.offeringList[name];
            var xml = this.obsformat.write({
                eventTime: 'latest',
                resultModel: 'om:Measurement',
                responseMode: 'inline',
                procedure: feature.attributes.id,
                offering: name,
                observedProperties: offering.observedProperties,
                responseFormat: this.responseFormat
            });
            OpenLayers.Request.POST({
                url: this.url,
                scope: this,
                failure: this.showPopup,
                success: this.showPopup,
                data: xml
            });
        }
    },
    destroy: function () {
    },
    CLASS_NAME: "OpenLayers.SOSClient"
});