Ext.define('App.view.asset.window', {
  alias: 'widget.assetwindow',
  extend: 'Ext.window.Window',

  width: 500,
  height: 500,
  
  layout: 'fit',

  initComponent: function() {
    this.title = this.record.get('title');

//    this.items = [{
//      border: false,
//      xtype: 'tabpanel',
//      activeTab: 'general',
//      items: [{
//        itemId: 'general',
//        title: 'General Information',
//        autoScroll: true,
//        loader: {
//          url: '/catalog/' + this.record.get('id'),
//          renderer: 'html',
//          autoLoad: true
//        }
//      }, {
//        itemId: 'metadata',
//        title: 'Metadata'
//      }, {
//        itemId: 'preview',
//        title: 'Preview'
//      }, {
//        itemId: 'links',
//        title: 'Links'
//      }, {
//        itemId: 'files',
//        title: 'Files'
//      }]
//    }];
    this.items = [{
      border: false,
      autoScroll: true,
      loader: {
        url: '/catalog/' + this.record.get('id'),
        renderer: 'html',
        autoLoad: true
      }
    }]
    this.dockedItems = [{
      xtype: 'toolbar',
      dock: 'bottom',
      items: [{
        xtype: 'button',
        scale: 'large',
        action: 'close',
        text: 'Close Window'
      }, '->', {
        xtype: 'button',
        scale: 'large',
        action: 'openfull',
        text: 'View Full Record >>'
      }]
    }];

    this.callParent(arguments);
  }
});