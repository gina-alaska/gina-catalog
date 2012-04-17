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
  
  saveRecord: function(form){
    Ext.Msg.wait('Saving asset information', 'Please Wait...');
    var values = form.getValues();
    var method;
    var url = '/catalog';
    if (form.record && form.record.id) {
      url += '/' + form.record.id;
      method = 'PUT';
    } else {
      method = 'POST';
    }
    
    /* Workaround for issue with exit and multi-selects */
    Ext.each(['geokeyword_ids', 'agency_ids', 'person_ids', 'iso_topic_ids'], function(item) {
      values[item + '[]'] = values[item];
      delete values[item];            
    }, this);
    
    Ext.Ajax.request({
      url: url,
      method: method,
      params: values,
      scope: form,
      success: function(response) {
        var obj = Ext.decode(response.responseText);
        if(obj.success) {
          this.loadRecordData(obj.catalog);
          Ext.Msg.alert('Success!', 'Asset information has been updated');
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
  
  doSearch: function(){
    var q = this.getSearch().getValue();
    this.getStore('Assets').filters.clear();
    this.getStore('Assets').filter([{ property: 'q', value: q }]);
  }
});
