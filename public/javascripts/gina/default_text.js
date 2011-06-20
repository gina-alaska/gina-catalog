Ext.ux.DefaultText = function(config) {
  config = config || { };

  Ext.apply(this, config);
  this.initalConfig = config;
  this.listeners = config.listeners || {};
  /* Install the default response listener */
  this.addEvents('load');

  this.setToDefault = function(input) {
    if(input.getValue() == null || input.getValue() == '') { input.setValue(this.text); }
  };

  Ext.ux.DefaultText.superclass.constructor.call(this);
};

Ext.extend(Ext.ux.DefaultText, Ext.util.Observable, {
  init: function(field) {
    var defaultText = this.text;

    field.setValue = field.setValue.createSequence(function(v) {
      if(v == defaultText) {
        this.addClass('default');
      } else {
        this.removeClass('default');
      }
    });
    field.getValueWithoutCheck = field.getValue;
    field.getValue = function() {
      var v = this.getValueWithoutCheck();
      return (v == defaultText ? '' : v);
    }.createDelegate(field)

    field.addClass('default');
    
    field.on('render', this.setToDefault, this, { delay: 100 });

    field.on('focus', function(input) {
      if(input.getValueWithoutCheck() == defaultText) { input.setValue(''); }
    }, this);

    field.on('blur', this.setToDefault, this);

    this.fireEvent('load', this)
  }
})