App.views.add('catalog-mappy-framework', function() {
  return {
    layout: 'border',
    tbar: ['Quick Search:', {
      xtype: 'textfield',
      width: 400
    }, '->', {
      icon: '/images/icons/small/viewmag.png',
      text: '<b>Advanced Search</b>'
    }, '-', {
      icon: '/images/icons/small/save.png',
      text: '<b>Export Search Results</b>'
    }],
    defaults: { margins: '5 0 0 0' },
    items: [
      App.view('catalog-map', [{
        region: 'center'
      }]),{
        region: 'west',
        split: true,
        width: 350,
        layout: 'fit',
        items: App.view('catalog-list', [{
          store: App.store('search_results')
        }])
      }
    ]
  }
});