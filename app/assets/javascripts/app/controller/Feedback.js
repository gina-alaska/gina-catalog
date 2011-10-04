Ext.define('App.controller.Feedback', {
  extend: 'Ext.app.Controller',

  views: ['feedback.index'],
  stores: [],
  models: [],

  init: function() {
    this.control({
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Contact Us"]': {
        click: this.show
      },
      'viewport > #center feedbackindex button[text="Submit"]': {
        click: this.submitFeedback
      }
    });
  },

  start: function(panel) {
    this.pages = {};
    this.pages.index = panel.add({ xtype: 'feedbackindex' });
  },

  show: function() {
    var panel = this.pages.index.up('panel');
    panel.getLayout().setActiveItem(this.pages.index);
  },

  submitFeedback: function(button) {
    var form = button.up('feedbackindex').down('form');
    form.submit();
  }
});