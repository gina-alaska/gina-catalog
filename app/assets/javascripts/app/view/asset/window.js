Ext.define('App.view.asset.window', {
  alias: 'widget.assetwindow',
  extend: 'Ext.window.Window',

  width: 500,
  height: 500,
  constrain: true,
  
  layout: 'fit',
  bodyStyle: 'background: white',
  
  config: {
    record: null
  },
  
  constructor: function(config) {
    this.initConfig(config);
    this.callParent();
  },

  initComponent: function() {
    this.title = this.getRecord().get('title');

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
        url: '/catalog/' + this.getRecord().get('id'),
        renderer: 'html',
        autoLoad: true
      },
      dockedItems: [{
        xtype: 'toolbar',
        dock: 'bottom',
        ui: 'footer',
        items: [{ 
          xtype: 'button',
          scale: 'large',
          action: 'download',
          text: 'Download',
          flex: 1,
          hidden: !this.getRecord().get('downloadable')
        }, {
          xtype: 'button',
          scale: 'large',
          action: 'close',
          flex: 1,
          text: 'Close Window'
        }]
      }]
    }];
    
    // this.dockedItems = ;

    this.callParent(arguments);
  }
});