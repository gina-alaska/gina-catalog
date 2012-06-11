Ext.define('Manager.controller.Asset', {
  extend: 'Ext.app.Controller',
  stores: ['Assets', 'AssetStatus', 'Agencies', 'Users', 'Contacts', 'Geokeywords', 'IsoTopics', 'DataTypes'],

  refs: [{
    ref: 'search',
    selector: 'assets_toolbar textfield'
  }, {
    ref: 'manager',
    selector: '#manager'
  }],

  init: function() {
    this.control({
      'assets_grid': {
        itemdblclick: function(grid, record) { 
          Ext.util.History.add('asset/'+record.get('id')); 
          this.showRecord({ id: record.get('id') }); 
        }
      },
      'assets_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'assets_toolbar textfield': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      
      'assets_form button[action="add_link"]': {
        click: function(button) {
          button.up('form').addLink({});
        }
      },
      'assets_form button[action="remove_link"]': {
        click: function(button) { this.removeLink(button.linkId, button.up('fieldcontainer[role="link"]')); }
      },
      
      'assets_form button[action="add_location"]': {
        click: function(button) {
          button.up('panel').addLocation({});
        }
      },
      'assets_form button[action="remove_location"]': {
        click: function(button) { this.removeLocation(button.locId, button.up('fieldcontainer[role="location"]')); }
      },
      
      'assets_form button[action="save"]': {
        click: function(button) { this.saveRecord(button.up('form')); }
      },
      'assets_form button[action="cancel"]': {
        click: function(button) {
          Ext.util.History.add('');
          var f = button.up('form');
          f.up('panel').remove(f);
        }
      },
      'assets_form button[action="publish"]': {
        click: function(button) { this.publishRecord(button.up('form')); }
      },
      'assets_toolbar button[action="new"]': {
        click: function(button) { this.newRecord(); }
      }
    });
  },
  
  newRecord: function(){
    var p = Ext.widget('assets_form');
    
    if(this.getManager()) {
      this.getManager().add(p);      
      this.getManager().getLayout().setActiveItem(p);
    }
  },
  
  assetRequest: function(record) {
    var url = '/catalog';
    if (record && record.id) {
      url += '/' + record.id;
      method = 'PUT';
    } else {
      method = 'POST';
    }
    
    return { url: url, method: method };
  },  
  
  saveRecord: function(form){
    Ext.Msg.wait('Saving asset information', 'Please Wait...');
    var values = form.getValues();
    var method;
    var url = '/catalog';
    
    var request = this.assetRequest(form.record)
        
    /* Workaround for issue with exit and multi-selects */
    Ext.each(['geokeyword_ids', 'agency_ids', 'person_ids', 'iso_topic_ids'], function(item) {
      values[item + '[]'] = values[item];
      delete values[item];            
    }, this);
    
    Ext.apply(request, {
      params: values,
      scope: form,
      success: function(response) {
        var obj = Ext.decode(response.responseText);
        if(obj.success) {
          this.loadRecordData(obj.catalog);
          Ext.Msg.alert('Success!', 'Asset information has been saved');
        } else {
          Ext.Msg.alert('Error', '<p>The following errors were encountered while saving the asset:</p><br />' + obj.errors.join('<br />'));
        }
        this.down('button[action="save"]').disable();
        this.down('button[action="validate"]').enable();
      },
      failure: function(response) {
        Ext.Msg.alert('Error', 'A server error was encountered while trying to save the asset');
      }
    });
    
    Ext.Ajax.request(request);
  },
  
  publishRecord: function(form) {
      Ext.Msg.wait('Publishing asset', 'Please Wait...');
      if(form.record.id == null) {
        return false;
      }
      var url = '/catalog/' + form.record.id + '/publish';
      Ext.Ajax.request({
        url: url,
        method: 'POST',
        scope: form,
        success: function(response) {
          var obj = Ext.decode(response.responseText);
          if(obj.success) {
            this.loadRecordData(obj.catalog);
            Ext.Msg.alert('Success!', 'Asset publish status has been changed');
          } else {
            Ext.Msg.alert('Error', '<p>The following errors were encountered while saving the asset:</p><br />' + obj.errors.join('<br />'));          
          }
        },
        failure: function(repsonse) {
          Ext.Msg.alert('Error', "A server error was encountered while trying to publish the asset");
        }
      });
  },

  showRecord: function(request) {
    var p = Ext.widget('assets_form', {
      recordId: request.id
    });
    
    if(this.getManager()) {
      this.getManager().add(p);      
      this.getManager().getLayout().setActiveItem(p);
    }
  },
  
  removeLink: function(linkId, linkContainer) {
    if(!linkId && linkContainer) {
      linkContainer.up('panel').remove(linkContainer);
    }
    if(linkId) {
      Ext.Ajax.request({
        url: '/links/' + linkId,
        method: 'delete',
        scope: this,
        success: function(response) {
          var obj = Ext.decode(response.responseText);
          if(obj.success) {
            this.removeLink(0, linkContainer);
          }
        }
      });
    }
  },
  
  removeLocation: function(locId, locContainer){
    if(!locId && locContainer) {
      locContainer.up('panel').remove(locContainer);
    }
    if(locId) { 
      var form = locContainer.up('form');
      var request = this.assetRequest(form.record);
      request.url += '/locations/' + locId;
      
      Ext.apply(request, {
        method: 'delete',
        scope: this,
        success: function(response) {
          var obj = Ext.decode(response.responseText);
          if(obj.success) {
            this.removeLocation(0, locContainer);
          }
        }
      });
      Ext.Ajax.request(request);
    }
  },  
  
  doSearch: function(){
    var q = this.getSearch().getValue();
    this.getStore('Assets').filters.clear();
    this.getStore('Assets').filter([{ property: 'q', value: q }]);
  }
});
