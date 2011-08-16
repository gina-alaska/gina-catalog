Ext.define('App.controller.Contact', {
  extend: 'Ext.app.Controller',

  views: ['contact.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Contact Us"]': {
        click: this.showHelp
      }
    });
  },

  start: function(panel) {
    this.pages = {};
    this.pages.index = panel.add({
      xtype: 'contactindex',
      html: 'Contact stuff goes here'
    });
  },

  showHelp: function() {
    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  }
});