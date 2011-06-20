App.controllers.add('catalog', {
  beforeFilter: function(params, request) {
    if(!this[request.action]) { this.redirectTo('catalog'); }
  },

  index: function() {
    this.framework = this.render('catalog-mappy-framework');
  },

  show: function(params, request) {
    //this.render('catalog-show');
  }
});