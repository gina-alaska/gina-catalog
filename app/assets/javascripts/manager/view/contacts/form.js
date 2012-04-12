Ext.define('Manager.view.contacts.Form', {
  extend: 'Ext.form.Panel',
  alias: 'widget.contacts_form',

  config: {
    recordId: null,
    recordType: 'agency'
  },
  
  titleTpl: new Ext.Template('Edit {id}::{full_name}'),

  constructor: function(config) {
    this.initConfig(config);
    this.callParent(arguments);
  },


  initComponent: function() {
    this.link_count = 0;
    this.location_count = 0;
    
    var links = [];
    
    Ext.apply(this, {
      title: 'Loading...',
      autoScroll: true,
      closable: true,
      border: true,
      fieldDefaults: { anchor: '100%', labelAlign: 'top' },
      defaults: { bodyStyle: 'padding: 3px;', layout: 'anchor', margin: '3 3 0 3' },
      dockedItems: [{
        xtype: 'toolbar', dock: 'bottom', ui: 'footer', cls: 'edit',
        defaults: { scale: 'large', minWidth: 100 },
        items: ['->', 
          { text: 'Cancel',action: 'cancel'}, 
          { text: 'Save', action: 'save' }
        ]
      }],
      layout: { type: 'hbox', pack: 'center' },
      items: [{
        border: false,
        width: 500,
        items: [    

          { xtype: 'textfield', fieldLabel: 'First Name', name: 'first_name' }, 
          { xtype: 'textfield', fieldLabel: 'Last Name', name: 'last_name' }, 
          { xtype: 'textfield', fieldLabel: 'Email', name: 'email' },
          { xtype: 'textfield', fieldLabel: 'URL', name: 'url' },
          { xtype: 'textfield', fieldLabel: 'Work Phone', name: 'work_phone' },
          { xtype: 'textfield', fieldLabel: 'Mobile Phone', name: 'mobile_phone' },
          { xtype: 'textfield', fieldLabel: 'Alt Phone', name: 'alt_phone' },
          { 
            xtype: 'combobox', 
            fieldLabel: 'Agencies', 
            name: 'agency_ids',
            store: 'Agencies',
            queryMode: 'local',
            displayField: 'name_with_acronym',
            valueField: 'id',
            editable: false,
            minChars: 3,
            multiSelect: true
          }
        ]
      }]

    });       
    this.callParent(arguments);

    if(this.getRecordId()) {
      Ext.Ajax.request({
        url: '/people/' + this.getRecordId() + '.json',
        success: this.onRequestSuccess,
        scope: this
      });        
    } else {
      this.setTitle('New Contact');
    }
  },

  onRequestSuccess: function(response) {
    console.log(response)
    this.loadRecordData(Ext.JSON.decode(response.responseText));
  },

  loadRecordData: function(record){
    this.record = record;
    console.log(this.record);
    this.setTitle(this.titleTpl.apply(this.record));
    this.getForm().setValues(this.record);

  },
});