/**
* @class Manager.shared_views.catalog.links_form_panel
* @extends Ext.panel.Panel
* Shared view for links form panel
*/
Ext.define('Manager.shared_views.catalog.links_form_panel', {
  extend: 'Ext.panel.Panel', 
  alias: 'widget.catalog_links_form_panel',

  initComponent: function() {
    Ext.apply(this, {
      dockedItems: [{
        xtype:'toolbar',
        dock: 'top',
        defaults: { scale: 'large' },
        items: [{ text: '<b>New Link</b>', action: 'add_link' }]
      }]
    });        
    this.link_count = 0;
    this.callParent(arguments);
  },
  
  reset: function() {
    this.removeAll();
    this.link_count = 0;
  },
    
  addLink: function(link){
    this.add(this.buildLink(link));      
  },
  
  buildLink: function(link){
    Ext.applyIf(link, {
      id: '',
      category: '',
      display_text: '',
      url: ''
    });
      
    var link_markup = {
      xtype: 'fieldcontainer',
      role: 'link',
      layout: { type: 'hbox', defaultMargins: { right: 3 } },
      fieldDefaults: { labelAlign: 'top' },
      items: [{
        xtype: 'hiddenfield', name: 'links_attributes['+this.link_count+'][id]', value: link.id
      }, {
        flex: 1,
        xtype: 'combobox', fieldLabel: 'Category', name: 'links_attributes['+ this.link_count +'][category]', 
        queryMode: 'local', store: 'LinkCategories',  displayField: 'category', valueField: 'category', 
        value: link.category
      }, {
        xtype: 'textfield', fieldLabel: 'Text', flex: 2,
        name: 'links_attributes['+ this.link_count + '][display_text]', value: link.display_text
      }, {
        xtype: 'textfield', fieldLabel: 'URL', flex: 10,
        name: 'links_attributes['+ this.link_count + '][url]', value: link.url
      }, {
        xtype: 'fieldcontainer',
        layout: 'hbox',
        flex: 1,
        fieldLabel: 'Actions',
        items: [{
          xtype: 'button', text: 'Remove', flex: 1, action: 'remove_link', linkId: link.id
        }]
      }]
    };   
    this.link_count += 1;
    return link_markup;     
  },
  
  
});