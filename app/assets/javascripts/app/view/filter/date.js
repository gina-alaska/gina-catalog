/**
 * @class App.view.catalog.datefilter
 * @extends Ext.window.Window
 * Popup window to select a daterange to filter by
 */
Ext.define('App.view.filter.date', {
    extend: 'Ext.window.Window', 
    alias: 'widget.filter_by_date',
    config: {
      field: '',
      fieldName: ''
    },
    layout: 'fit',
    autoHeight: true,
    
    constructor: function(config){
      this.initConfig(config);
      this.callParent(arguments);
    },
    initComponent: function() {
      this.addEvents('submit');
      
      var defaultYear = Ext.create('Ext.gina.DefaultText', {
        text: 'YYYY'
      });
      
      this.title = 'Filter by ' + this.getFieldName() + ' Year';
      this.items = [{
        xtype: 'form',
        bodyStyle: 'padding: 3px;',
        border: false,
        fieldDefaults: { anchor: '100%' },
        items: [{
          xtype: 'fieldcontainer',
          layout: 'hbox',
          fieldLabel: this.getFieldName(),
          items: [{
            flex: 1,
            xtype: 'combo',
            queryMode: 'local',
            displayField: 'display',
            valueField: 'id',
            name: 'type',
            value: 'after',
            forceSelection: true,
            store: Ext.create('Ext.data.Store', {
              fields: ['id', 'display'],
              data: [{
                id: 'after',
                display: 'After'
              }, {
                id: 'before',
                display: 'Before'
              }]
            })
          }, { xtype: 'splitter' }, {
            xtype: 'numberfield',
            name: 'year',
            allowBlank: false,
            flex: 2,
            plugins: [defaultYear],
            minValue: 1900,
            maxValue: 3000
          }]
        }]
      }];
      
      this.dockedItems = [{
        xtype: 'toolbar',
        dock: 'bottom',
        ui: 'footer',
        items: ['->', {
          text: 'Cancel',
          scope: this,
          scale: 'medium',
          handler: function() { this.close(); }
        }, {
          text: 'Submit',
          scope: this,
          scale: 'medium',
          handler: function(){
            var values = this.down('form').getForm().getValues();
            var tpl = new Ext.XTemplate(this.description);

            this.callback.call(this.scope, {
              filterType: this.filterType || "single",
              field: this.field + "_" + values.type,
              description: tpl.apply(values),
              value: values.year
            });
            this.close();
          }
        }]
      }];

      this.callParent(arguments);
    }
});