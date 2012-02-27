Ext.define('Manager.controller.Project', {
  extend: 'Ext.app.Controller',
  stores: ['Projects', 'ProjectStatus', 'Agencies'],

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
