Ext.define('Ext.gina.Notify', {
  singleton: true,
  container: null,

  createBox: function(t, s) {
    return '<div class="notify"><p>' + s + '</p><br /><p class="dismiss">Click here to dismiss</p></div>';
  },

  show: function(title, format) {
    if (!this.container) {
      this.container = Ext.core.DomHelper.insertFirst(document.body, { id: 'notify-div' }, true);
    }
    var s = Ext.String.format.apply(String, Array.prototype.slice.call(arguments, 1));
    var notice = Ext.core.DomHelper.append(this.container, this.createBox(title, s), true);
    notice.hide();
    notice.slideIn('t').ghost("t", {
        delay: 15000,
        remove: true
    });
    
    notice.on('click', this.hideMessage, this, { notice: notice })
  },

  hideMessage: function(e, el, opts) {
    opts.notice.stopAnimation();
  }
});
