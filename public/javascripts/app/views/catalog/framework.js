App.views.add('catalog-framework', function() {
//    {
//      icon: '/images/icons/small/agency.png',
//      text: '<b>Agencies</b>'
//    }, '-', {
//      icon: '/images/icons/small/user.png',
//      text: '<b>Contacts</b>'
//    }, '-',
  return {
    layout: 'border',
    tbar: ['->', 'Quick Search:', {
      xtype: 'textfield',
      width: 200
    }, '-', {
      icon: '/images/icons/small/viewmag.png',
      text: '<b>Advanced Search</b>'
    }, '-', {
      icon: '/images/icons/small/save.png',
      text: '<b>Export Search Results</b>'
    }],
    defaults: { margins: '5 0 0 0' },
    items: [
      {
        region: 'west',
        border: false,
        width: 500,
        split: true,
        collapseMode: 'mini',
        layout: 'border',
        items: [
          App.view('catalog-map'),
          App.view('catalog-preview')
        ]
      },
      App.view('catalog-grid')
    ]
  }
});