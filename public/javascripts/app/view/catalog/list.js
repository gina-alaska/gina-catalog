Ext.define('App.view.catalog.list', {
  extend: 'Ext.view.View',
  alias: 'widget.resultslist',
  store: 'SearchResults',
  title: 'Search Results',

  tpl: new Ext.XTemplate(
    '<tpl for=".">',
      '<div class="asset_wrap" id="asset_{id}">',
        '<div class="title">{title}</div>',
        '<tpl if="description">',
          '<div class="description">{description}...</div>',
        '</tpl>',
        '<div class="detail">',
          '<label>Type:</label>&nbsp;{type} ',
          '<label>Source:</label>&nbsp;{source_agency_acronym} ',
          '<label>Status:</label>&nbsp;{status} ',
          '<tpl if="start_date_year">',
            '<label>Start:</label>&nbsp;{start_date_year} ',
          '</tpl>',
          '<tpl if="end_date_year">',
            '<label>End:</label>&nbsp;{end_date_year} ',
          '</tpl>',
          '<label>Location:</label>&nbsp;',
          '<tpl if="this.hasGeom(locations)">Yes</tpl>',
          '<tpl if="!this.hasGeom(locations)">No</tpl>',
          '<tpl if="geokeywords.length &gt; 0">',
            '<label>Regions:</label>&nbsp;{geokeywords}',
          '</tpl>',
        '</div>',
      '</div>',
    '</tpl>',
    {
      compiled: true,
      hasGeom: function(locations) {
        return Ext.Array.some(locations, function(l) { if (l.wkt) { return true } });
      }
    }
  ),

  autoScroll: true,
  trackOver: true,
  overItemCls: 'x-item-over',
  itemSelector: 'div.asset_wrap',
  loadMask: true,
  loadingText: 'Loading assets...',
  singleSelect: true,
  allowDeselect: true,
  emptyText: 'No assets were found'
});