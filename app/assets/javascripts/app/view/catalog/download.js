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
        width: 300,
        url: '/catalog/' + this.getRecord().get('id') + '.zip',
        text: 'Download!'
      }],
      dockedItems: this.closeButton()
      
    }
  },
  
  userInfoCard: function(data) {
    var buttons = this.acceptanceButtons(this.current_card += 1, 'user-info-card');
    
    return {
      xtype: 'form',
      url: '/contact_infos',
      method: 'POST',
      itemId: 'user-info-card',
      defaults: { border: false, anchor: '100%' },
      defaultType: 'textfield',
      layout: {
        type: 'vbox',
        align: 'stretch',
        pack: 'center',
        padding: '5px'
      },
      items: [{
        itemId: 'title',
        xtype: 'panel',
        bodyCls: 'title',
        html: 'Please provide the following information, some better text should go here',
        padding: '0 0 5px 0'
      },{
        name: 'info[name]',
        fieldLabel: 'Name'
      }, {
        name: 'info[email]',
        fieldLabel: 'Email'
      }, {
        name: 'info[phone_number]',
        fieldLabel: 'Phone Number'
      }, {
        name: 'info[usage_description]',
        fieldLabel: 'Brief description of the intended use for this dataset',
        labelAlign: 'top',
        xtype: 'textarea',
        flex: 1
      }, {
        xtype: 'hiddenfield',
        name: 'catalog_id',
        value: this.getRecord().get('id')
      }],
      dockedItems: buttons
    }
  },
  
  useAgreementCard: function(data) {
    //TODO: Add check here to determine where next button goes based on requirements
    var buttons =  this.acceptanceButtons(this.current_card += 1);
    
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
        html: data.title
      }, {
        itemId: 'info',
        bodyCls: 'info',
        html: 'Acceptance of the data use agreement is required to download this dataset',
        hidden: !data.required
      }, {
        itemId: 'content',
        flex: 1,
        xtype: 'textarea',
        value: data.content
      }],
      dockedItems: buttons
    };
  },
  
  handleDownload: function(xhr) {
    this.current_card = 1;
    data = Ext.decode(xhr.responseText);
    if (data.use_agreement) {
      this.add(this.useAgreementCard(data.use_agreement));
    }    
    if (data.request_contact_info) {
      this.add(this.userInfoCard())
    }
    
    this.add(this.downloadCard());
      
    this.getLayout().setActiveItem(1);    
    // this.updateContent(data);
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
  
  acceptanceButtons: function(nextCard, form) {
    if(form) {
      console.log(form);
      nextHandler = function() {
        this.down('#' + form).submit({
          scope: this,
          success: function(form, action) {
            this.getLayout().setActiveItem(nextCard);
          },
          failure: function(form, action) {
            switch (action.failureType) {
              case Ext.form.action.Action.CLIENT_INVALID:
                  Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
                  break;
              case Ext.form.action.Action.CONNECT_FAILURE:
                  Ext.Msg.alert('Failure', 'Ajax communication failed');
                  break;
              case Ext.form.action.Action.SERVER_INVALID:
                 Ext.Msg.alert('Failure', action.result.msg.join('<br />'));
            }
          }        
        });
      }
    } else {
      nextHandler = function() {
        this.getLayout().setActiveItem(nextCard);
      }
    }
    
    return {
      xtype: 'toolbar',
      dock: 'bottom',
      ui: 'footer',
      items: [{
        text: 'Cancel',
        scale: 'large',
        scope: this,
        flex: 1,
        handler: function() { this.close(); }
      }, {
        text: 'Continue &raquo;',
        scale: 'large',
        scope: this,
        flex: 1,
        handler: nextHandler
      }]
    };    
  },
  
  closeButton: function() {
    return {
      xtype: 'toolbar',
      dock: 'bottom',
      ui: 'footer',
      items: [{
        text: 'Close',
        scope: this,
        scale: 'large',
        flex: 1,
        handler: function() { this.close(); }
      }]
    };
  }
});
