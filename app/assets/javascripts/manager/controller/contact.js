Ext.define('Manager.controller.Contact', {
  extend: 'Ext.app.Controller',

  stores: ['Agencies'],

  refs: [{
    ref: 'search',
    selector: 'contacts_toolbar textfield'
  }, {
    ref: 'manager',
    selector: '#manager'
  }, {
    ref: 'grid',
    selector: 'contacts_grid'
  }],

  init: function() {
    this.control({
      'contacts_grid': {
        itemdblclick: function(grid, record) { 
          Ext.util.History.add('contact/'+record.get('id'));
          this.showRecord({ id: record.get('id') }); 
        }
      },
      'contacts_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'contacts_toolbar textfield': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      'contacts_form button[action="save"]': {
        click: function(button) { this.saveRecord(button.up('form')); }
      },
      'contacts_form button[action="cancel"]': {
        click: function(button) {
          Ext.util.History.add('');
          var f = button.up('form');
          f.up('panel').remove(f);
        }
      },
      'contacts_grid button[action="new"]': {
        click: function(button) { this.newRecord(); }
      }
    });
  },
  
  newRecord: function(){
    var p = Ext.widget('contacts_form');
    
    if(this.getManager()) {
      this.getManager().add(p);      
      this.getManager().getLayout().setActiveItem(p);
    }
  },
  
  contactRequest: function(record) {
    var url = '/people';
    if (record && record.id) {
      url += '/' + record.id;
      method = 'PUT';
    } else {
      method = 'POST';
    }
    
    return { url: url, method: method };
  },
  
  saveRecord: function(form){
    Ext.Msg.wait('Saving contact information', 'Please Wait...');
    
    request = this.contactRequest(form.record);
    request.params = form.getValues();
    /* Workaround for issue with exit and multi-selects */
    Ext.each(['agency_ids'], function(item) {
      //This is a work around for ExtJS stripping out empty arrays
      if(Ext.isArray(this[item]) && this[item].length == 0) {
        this[item] = [""];
      }
      this[item + '[]'] = this[item];
      delete this[item];            
    }, request.params);   
    Ext.apply(request, {
      scope: form,
      success: function(response) {
        var obj = Ext.decode(response.responseText);
        if(obj.success) {
          this.loadRecordData(obj.person);
          Ext.Msg.alert('Success!', 'Contact information has been updated');
        } else {
          Ext.Msg.alert('Error', '<p>The following errors were encountered while saving the contact:</p><br />' + obj.errors.join('<br />'));
        }
      },
      failure: function(response) {
        Ext.Msg.alert('Error', 'A server error was encountered while trying to save the contact');
      }      
    });
    Ext.Ajax.request(request);
  },
  
  showRecord: function(request) {
    var p = Ext.widget('contacts_form', {
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
      var request = this.contactRequest(form.record);
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
    this.getGrid().getStore().filters.clear();
    this.getGrid().getStore().filter({ property: 'query', value: q });
  }
});
