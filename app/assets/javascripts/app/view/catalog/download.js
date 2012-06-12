Ext.define('App.view.catalog.download', {
  alias: 'widget.downloadwindow',
  extend: 'Ext.window.Window',

  width: 500,
  height: 500,
  constrain: true,
  
  layout: 'fit',
  
  config: {
    record: null
  },
  
  constructor: function(config) {
    this.initConfig(config);
    this.callParent();
  },

  initComponent: function() {
    Ext.apply(this, {
      title: 'Download ' + this.getRecord().get('title'),
      layout: 'card',
      bodyCls: 'download',      
      bodyStyle: 'background-color: white;',
      defaults: { border: false, plain: true },
      items: [this.pleaseWaitCard()],
      activeItem: 0   
    });
    
    var request = {
      url: '/catalog/' + this.getRecord().get('id') + '/download.json',
      scope: this,
      success: this.handleDownload,
      failure: this.handleFailure
    }
    Ext.Ajax.request(request);
  
    this.callParent(arguments);
  },
  
  pleaseWaitCard: function() {
    return {
      itemId: 'please-wait-card',
      layout: {
        type: 'vbox',
        align: 'center',
        pack: 'center'
      },
      items: [{
        bodyCls: 'info',
        border: false,
        html: 'Please wait while we prepare the data for download...'
      }]
    }
  },
  
  downloadCard: function() {
    return {
      itemId: 'download-card',
      layout: {
        type: 'vbox',
        align: 'center',
        pack: 'center'
      },
      items: [{
        border: false,
        bodyCls: 'info',
        margin: '0 0 10px 0',
        html: 'Please click the button below to start your download!'
      }, {
        xtype: 'button',
        scale: 'large',
        url: '/catalog/' + this.getRecord().get('id') + '.zip',
        text: 'Download!'
      }]
    }
  },
  
  useAgreementCard: function(data) {
    //TODO: Add check here to determine where next button goes based on requirements
    var buttons =  this.acceptanceButtons('download-card');
    
    return {
      itemId: 'use-agreement-card',
      defaults: { border: false },
      layout: {
        type: 'vbox',
        align: 'stretch',
        padding: '5px;'
      },
      items: [{
        itemId: 'title',
        bodyCls: 'title',
        html: 'Preparing data for download....'
      }, {
        itemId: 'info',
        bodyCls: 'info',
        hidden: true,
        html: 'Acceptance of the data use agreement is required to download this dataset'
      }, {
        itemId: 'content',
        flex: 1,
        xtype: 'textarea'
      }],
      dockedItems: buttons
    };
  },
  
  handleDownload: function(xhr) {
    data = Ext.decode(xhr.responseText);
    
    this.add(this.useAgreementCard(data), this.downloadCard());
    this.getLayout().setActiveItem('use-agreement-card');    
    this.updateContent(data);
  },
  
  handleFailure: function(){
  },
  
  updateContent: function(data) {
    this.down('#title').update(data.title);
    this.down('#content').setValue(data.content);
    if(data.required) {
      this.down('#info').show();
    }
  },
  
  addButtons: function(data) {
    if(data && data.required) {
      this.addAcceptanceButtons();
    } else {
      this.addCloseButton();
    }
  },
  
  acceptanceButtons: function(nextCard) {
    return {
      xtype: 'toolbar',
      dock: 'bottom',
      items: ['->', {
        text: 'Decline',
        scale: 'large',
        scope: this,
        handler: function() { this.close(); }
      }, {
        text: 'Accept',
        scale: 'large',
        scope: this,
        handler: function() {
          this.getLayout().setActiveItem(nextCard);
        }
      }]
    };    
  },
  
  closeButton: function() {
    return {
      xtype: 'toolbar',
      dock: 'bottom',
      items: ['->', {
        text: 'Close',
        scope: this,
        scale: 'large',
        handler: function() { this.close(); }
      }]
    };
  }
});
