App.controllers.add('catalog', {
  beforeFilter: function() {
    this.framework = this.render('catalog-mappy-framework');
  },

  index: function() {
    console.log('test');
  }
});