Ext.define('App.view.asset.details', {
  alias: 'widget.assetdetails',
  extend: 'Ext.panel.Panel',

  border: false,
  layout: 'border',

  initComponent: function() {
    this.addEvents('back');

    this.toolbar = Ext.create('Ext.toolbar.Toolbar', {
      dock: 'top',
      items: [{
        scale: 'medium',
        text: '<< Back to Catalog',
        scope: this,
        handler: function(btn) {
          this.fireEvent('back', btn);
        }
      }]
    });

    this.dockedItems = [this.toolbar];

    this.items = [{
      itemId: 'content',
      region: 'center',
      autoScroll: true,
      margins: '3 0 0 0',
      loader: { loadMask: true },
      contentEl: 'content'
    }, {
      region: 'east',
      width: 400,
      split: true,
      border: false,
      margins: '3 0 0 0',
      layout: 'border',
      items: [{
        region: 'north',
        height: 400,
        split: true,
        xtype: 'assetmap'
      }, {
        region: 'center',
        html: 'Other content goes here'
      }]
    }];

    this.callParent();
  }
});