Ext.define('App.controller.Rails', {
  extend: 'Ext.app.Controller',

  refs: [{
    ref: 'content',
    selector: 'viewport > #center'
  }],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      }
    });
  },

  start: function(panel) {
    this.page = panel.add({
      xtype: 'panel',
      border: false,
      layout: {
        type: 'hbox',
        pack: 'center'
      },
      items: [{
        border: false,
        contentEl: 'content'        
      }]
    });
  },

  show: function() {
    /* This is a workaround to handle the slow loading of other cards when lots of results are shown */
    this.getContent().getLayout().setActiveItem(this.page);
  }
});