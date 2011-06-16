App.views.add('catalog-preview', function() {
  var defaultMsg = '<div class="item_preview_instructions">' +
                  '<div>Click an item in the search results to preview it here</div>' +
                  '<div>Click on a tab above to view specific information for the selected item</div>' +
               '</div>'

  var loadContentPlugin = {
    init: function(panel) {
      panel.items.each(function(p) {
        p.loadContent = function() {
          if(this.ownerCt.ctxRecord) {
            var loadUrl = this.urlTpl.apply(this.ownerCt.ctxRecord.data);
            this.getUpdater().update({
              url: loadUrl,
              method: 'GET'
            });
          }
        }
        p.on('show', p.loadContent, p);
      }, this);
    }
  }

  return {
    region: 'center',
    xtype: 'tabpanel',
    activeTab: 0,
    resizeTabs: true,
    deferredRender: false,
    plugins: [loadContentPlugin],
    items: [{
      itemId: 'general',
      title: 'General',
      defaultHtml: defaultMsg,
      html: defaultMsg,
      autoScroll: true,
      urlTpl: new Ext.Template('/catalog/{id}.html')
    }, {
      itemId: 'metadata',
      title: 'Metadata',
      urlTpl: new Ext.Template('/catalog/{id}.html')
    }, {
      itemId: 'links',
      title: 'Links',
      urlTpl: new Ext.Template('/catalog/{id}.html')
    }, {
      itemId: 'previews',
      title: 'Previews',
      urlTpl: new Ext.Template('/catalog/{id}.html')
    }, {
      itemId: 'files',
      title: 'files',
      urlTpl: new Ext.Template('/catalog/{id}.html')
    }],
    listeners: {
      render: function(panel) {
        var grid = panel.ownerCt.ownerCt.get('grid');
        grid.getSelectionModel().on('rowselect', function(sm, index, record) {
          this.ctxRecord = record
          this.getActiveTab().loadContent();
        }, panel);
      }
    }
  };
});