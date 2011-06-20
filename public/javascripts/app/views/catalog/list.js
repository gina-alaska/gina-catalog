App.views.add('catalog-list', function(config) {
  var menu = new Ext.ux.ContextMenu({
    "forceSelection": true,
    "menus": {
      "default": [{
        "text": "View",
        handler: function(menu, e) {
          App.nav.load('catalog/show/' + e.ctxRecords[0].get('id'))
        }
      }]
    }
  });

  var _panel = {
    itemId: 'results',
    xtype: 'dataview',
    autoScroll: true,
    overClass: 'x-view-over',
    selectedClass: 'x-view-selected',
    itemSelector: 'div.asset_wrap',
    loadingText: 'Loading assets...',
    singleSelect: true,
    plugins: [menu],
    tpl: new Ext.XTemplate(
      '<tpl for=".">',
        '<div class="asset_wrap" id="asset_{id}">',
          '<div class="title">{title}</div>',
          '<tpl if="description">',
            '<div class="description">{description}...</div>',
          '</tpl>',
          '<div class="type detail"><label>Type:</label> {type}</div>',
          '<div class="source detail"><label>Source:</label> {source_agency_acronym}</div>',
          '<div class="status detail"><label>Status:</label> {status}</div>',
          '<div class="x-clear"></div>',
          '<div class="start detail"><label>Start:</label> {start_date_year}</div>',
          '<tpl if="end_date_year">',
            '<div class="end detail"><label>End:</label> {end_date_year}</div>',
          '</tpl>',
          '<div class="x-clear"></div>',
        '</div>',
        '<div class="x-clear"></div>',
      '</tpl>',
    {
      compiled: true, urlize: function(string) { if(string) { return string.gsub(/[\s]+/,'-'); } }
    }),
    emptyText: 'No assets were found',
    listeners: {
      render: function(panel) {
        /* fullCatalogDataSet gets created by the fullpage load of /data.js */
        panel.getStore().loadData.defer(300, panel.getStore(), [App.fullCatalogDataset])
        //panel.getStore().load.defer(200, panel.getStore());

        panel.on('selectionchange', function(dv) {
          var selected = this.getSelectedRecords();
          if(selected.length > 0) {
            this.ownerCt.ownerCt.get('map').showSelectedFeature(selected[0].get('id'));
          } else {
            this.ownerCt.ownerCt.get('map').showAllFeatures();
          }
        }, panel, { buffer: 200 });
      }
    }
  };
  
  Ext.apply(_panel, config);

  return _panel;
});