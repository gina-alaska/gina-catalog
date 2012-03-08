Ext.define('Manager.controller.Project', {
  extend: 'Ext.app.Controller',
  stores: ['Projects', 'ProjectStatus', 'Agencies', 'Users', 'Contacts', 'Geokeywords'],

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
      'button[action="save"]': {
        click: function(button) {
          Ext.Msg.wait('Saving project information', 'Please Wait...');
          var form = button.up('form'),
              values = form.getValues();
          
          var url = '/catalog';
          if (form.record.id) {
            url += '/' + form.record.id;
            method = 'PUT';
          } else {
            method = 'POST';
          }
          
          /* Workaround for issue with exit and multi-selects */
          Ext.each(['geokeyword_ids', 'agency_ids', 'person_ids'], function(item) {
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
                this.loadRecord(obj.catalog);
                Ext.Msg.alert('Success!', 'Project information has been updated');
              } else {
                Ext.Msg.alert('Error', 'Errors were encountered while saving the form');
              }
            },
            failure: function(response) {
              Ext.Msg.alert('Error', 'A server error was encountered while trying to save the project');
            }
          });
        }
      }
    });
  },
  
  showRecord: function(request) {
    var p = Ext.widget('project_edit', {
      recordId: request.params.id
    });
    
    if(this.getManager()) {
      this.getManager().add(p);      
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
