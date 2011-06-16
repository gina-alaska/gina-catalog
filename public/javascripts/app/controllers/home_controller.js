App.controllers.add('home', {
  index: function() {
    if(!App.current_user.logged_in()) {
      App.view('home-welcome-window').show();
    }
    this.redirectTo('catalog');
  }
})