Ext.define('Manager.controller.Project', {
  extend: 'Ext.app.Controller',
  stores: ['Projects', 'ProjectStatus', 'Agencies', 'Users', 'Contacts', 'Geokeywords', 'IsoTopics', 'LinkCategories'],

  refs: [{
    ref: 'search',
    selector: 'projects_toolbar textfield'
  }, {
    ref: 'manager',
    selector: '#manager'
  }],

  init: function() {
    this.control({
      'projects_grid': {
        itemdblclick: function(grid, record) { 
          Ext.util.History.add('project/'+record.get('id'));
          this.showRecord({ id: record.get('id') }); 
        }
      },
      'projects_toolbar button[action="search"]': {
        click: this.doSearch
      },
      'projects_toolbar textfield': {
        specialkey: function(field, e) {
          if(e.getKey() === e.ENTER) { this.doSearch(); }
        }
      },
      'projects_form button[action="add_link"]': {
        click: function(button) {
          button.up('form').addLink({});
        }
      },
      'projects_form button[action="add_location"]': {
        click: function(button) {
          button.up('form').addLocation({});
        }
      },
      'projects_form button[action="save"]': {
        click: function(button) { this.saveRecord(button.up('form')); }
      },
      'projects_grid button[action="new"]': {
        click: function(button) { this.newRecord(); }
      } ,
      'projects_form button[action="remove_link"]': {
        click: function(button) { this.removeLink(button.linkId, button.up('fieldcontainer[role="link"]')); }
      },
      'projects_form button[action="remove_location"]': {
        click: function(button) { this.removeLocation(button.locId, button.up('fieldcontainer[role="location"]')); }
      }
    });
  },
  
  newRecord: function(){
    var p = Ext.widget('projects_form');
    
    if(this.getManager()) {
      this.getManager().add(p);      
      this.getManager().getLayout().setActiveItem(p);
    }
  },
  
  projectRequest: function(record) {
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
    Ext.Msg.wait('Saving project information', 'Please Wait...');
    
    request = this.projectRequest(form.record);
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
          Ext.Msg.alert('Success!', 'Project information has been updated');
        } else {
          Ext.Msg.alert('Error', '<p>The following errors were encountered while saving the project:</p><br />' + obj.errors.join('<br />'));
        }
      },
      failure: function(response) {
        Ext.Msg.alert('Error', 'A server error was encountered while trying to save the project');
      }      
    });
    
    Ext.Ajax.request(request);
  },
  
  showRecord: function(request) {
    var p = Ext.widget('projects_form', {
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
      var request = this.projectRequest(form.record);
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
    this.getStore('Projects').filters.clear();
    this.getStore('Projects').filter([{ property: 'q', value: q }]);
    // this.getStore('Projects').loadPage(1, {
    //   params: { 'search[q]': q }
    // });
  }
});
