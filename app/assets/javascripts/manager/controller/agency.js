Ext.define('Manager.controller.Agency', {
  extend: 'Ext.app.Controller',
  stores: ['Agencies'],

  refs: [{
    ref: 'search',
    selector: 'agencies_toolbar textfield'
  }, {
    ref: 'manager',
    selector: '#manager'
  }, {
    ref: 'grid',
    selector: 'agencies_grid'
  }],

  init: function() {
    this.control({
      'agencies_grid': {
        itemdblclick: function(grid, record) { 
          Ext.util.History.add('agency/'+record.get('id'));
          this.showRecord({ id: record.get('id') }); 
        }
      },
      'agencies_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'agencies_toolbar textfield': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      'agencies_form button[action="add_link"]': {
        click: function(button) {
          button.up('form').addLink({});
        }
      },
      'agencies_form button[action="add_location"]': {
        click: function(button) {
          button.up('form').addLocation({});
        }
      },
      'agencies_form button[action="save"]': {
        click: function(button) { this.saveRecord(button.up('form')); }
      },
      'agencies_form button[action="cancel"]': {
        click: function(button) {
          Ext.util.History.add('');
          var f = button.up('form');
          f.up('panel').remove(f);
        }
      },
      'agencies_grid button[action="new"]': {
        click: function(button) { this.newRecord(); }
      } ,
      'agencies_form button[action="remove_link"]': {
        click: function(button) { this.removeLink(button.linkId, button.up('fieldcontainer[role="link"]')); }
      },
      'agencies_form button[action="remove_location"]': {
        click: function(button) { this.removeLocation(button.locId, button.up('fieldcontainer[role="location"]')); }
      }
    });
  },
  
  newRecord: function(){
    var p = Ext.widget('agencies_form');
    
    if(this.getManager()) {
      this.getManager().add(p);      
      this.getManager().getLayout().setActiveItem(p);
    }
  },
  
  agencyRequest: function(record) {
    var url = '/agencies';
    if (record && record.id) {
      url += '/' + record.id;
      method = 'PUT';
    } else {
      method = 'POST';
    }
    
    return { url: url, method: method };
  },
  
  saveRecord: function(form){
    Ext.Msg.wait('Saving agency information', 'Please Wait...');
    
    request = this.agencyRequest(form.record);
    request.params = form.getValues();
    
    /* Workaround for issue with exit and multi-selects */
    Ext.each(['geokeyword_ids', 'agency_ids', 'person_ids', 'iso_topic_ids'], function(item) {
      this[item + '[]'] = this[item];
      delete this[item];            
    }, request.params);
    
    Ext.apply(request, {
      scope: form,
      success: function(response) {
        var obj = Ext.decode(response.responseText);
        if(obj.success) {
          this.loadRecordData(obj.catalog);
          Ext.Msg.alert('Success!', 'Agency information has been updated');
        } else {
          Ext.Msg.alert('Error', '<p>The following errors were encountered while saving the agency:</p><br />' + obj.errors.join('<br />'));
        }
      },
      failure: function(response) {
        Ext.Msg.alert('Error', 'A server error was encountered while trying to save the agency');
      }      
    });
    
    Ext.Ajax.request(request);
  },
  
  showRecord: function(request) {
    var p = Ext.widget('agencies_form', {
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
      var request = this.agencyRequest(form.record);
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
    this.getGrid().getStore().filter([{ property: 'query', value: q }]);
  }
});
