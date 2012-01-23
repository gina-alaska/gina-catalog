Ext.define('Ext.gina.SelectorWindow', {
  extend: 'Ext.window.Window',
  alias: 'widget.selector',

  title: 'Select an item',
  layout: 'fit',
  width: 500,
  height: 500,
  columns: [],

  initComponent: function() {
    this.addEvents('selected');

    if(Ext.isString(this.store)) {
      this.store = Ext.create(this.store);
    }
    this.store.load();
    var qs = Ext.widget('quicksearch', {
      dock: 'top',
      width: 490,
      store: this.store
    });

    this.dockedItems = [qs, {
      xtype: 'toolbar',
      dock: 'bottom',
      ui: 'footer',
      items: ['->', {
        scale: 'medium',
        text: 'Close',
        handler: function(button) {
          button.up('window').close();
        }
      }, {
        scale: 'medium',
        text: 'Submit',
        handler: this.onSubmit
      }]
    }];

    this.items = [{
      xtype: 'grid',
      store: this.store,
      border: false,
      // forceFit: true,
      autoExpandColumn: this.autoExpandColumn,
      columns: this.columns,
      listeners: {
        scope: this,
        itemdblclick: this.onSubmit
      }
    }];

    this.callParent(arguments);
  },

  onSubmit: function(item) {
    var win = item.up('window'),
        grid = win.down('gridpanel'),
        selected = grid.getSelectionModel().getSelection();
    
    var ids = [], descriptions = [];
    var tpl = new Ext.XTemplate(this.description);
    
    Ext.each(selected, function(item) {
      descriptions.push(tpl.apply(item.data));
      ids.push( item.get('id'));
    },this);
    console.log("Window", this);
    win.callback.call(win.scope, {
      filterType: this.filterType || "single",
      field: this.field,
      description: descriptions,
      value: ids
    });

    win.close();
    //win.fireEvent('selected', win, selected);
  }
});