Ext.ux.Notify = {
  /* Default notification just does a popup */
  show: function(title, msg) {
    var win = new Ext.ux.Notify.window({ html: msg }).show(document);
  }
}

Ext.ux.NotifyMgr = {
  positions: []
}

Ext.ux.Notify = function(){
  var msgCt;

  function createBox(t, s){
    s += '<div style="margin-top:10px; font-size: 12px;">(Click here to close this message)</div>';
    return ['<div class="msg">',
            '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
            '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc">', s, '</div></div></div>',
            '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
            '</div>'].join('');
  }
  return {
    show: function(title, format) {
      if(typeof format == 'object') {
        Ext.each(format, function(item) {
          var msg = this.createMsg(title, item);
          msg.slideIn('b', { duration: 1, callback:this.afterShow.createDelegate(this, [msg]), scope: this });
        }, this)
      } else {
        var msg = this.createMsg(title, format);
        msg.slideIn('b', { duration: 1, callback:this.afterShow.createDelegate(this, [msg]), scope: this });
      }
    },

    createMsg : function(title, format){
      if(!msgCt){
        msgCt = Ext.DomHelper.insertFirst(document.body, {id:'msg-div', style: 'margin: 0 auto;'}, true);
        msgCt.alignTo(document, 'tr-tr');
      }
      msgCt.alignTo(document, 'tr-tr');

      var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
      return Ext.DomHelper.append(msgCt, {html:createBox(title, s)}, true);
    },

    afterShow: function(m) {
      var task = new Ext.util.DelayedTask(this.animHide.createDelegate(this, [m]), this);
      task.delay(10000);

      Ext.get(m).on('click', function() {
        task.cancel();
        this.animHide(m);
      }, this);
    },

    animHide: function(m) {
      Ext.ux.NotifyMgr.positions.remove(this.pos);

      m.ghost('t', {
        duration: 1,
        remove: true
      });
    },

    init : function(){
      /*
      var t = Ext.get('exttheme');
      if(!t){ // run locally?
          return;
      }
      var theme = Cookies.get('exttheme') || 'aero';
      if(theme){
          t.dom.value = theme;
          Ext.getBody().addClass('x-'+theme);
      }
      t.on('change', function(){
          Cookies.set('exttheme', t.getValue());
          setTimeout(function(){
              window.location.reload();
          }, 250);
      });*/

      var lb = Ext.get('lib-bar');
      if(lb){
          lb.show();
      }
    }
  };
}();
Ext.onReady(Ext.ux.Notify.init, Ext.ux.Notify)

//Ext.ux.Notify.window = Ext.extend(Ext.Window, {
//  initComponent: function() {
//    Ext.apply(this, {
//      width: 300,
//      shadow: false,
//      autoHeight: true,
//      plain: true,
//      draggable: false,
//      border: false,
//      bodyStyle: 'text-align: center; padding: 5px; font-size: 1.3em;',
//      closable: false,
//      autoHide: true,
//      hideDelay: 5000
//    });
//
//    if(this.autoHide) {
//      this.task = new Ext.util.DelayedTask(this.hide, this);
//    } else {
//      this.closable = true;
//    }
//
//    Ext.ux.Notify.window.superclass.initComponent.call(this);
//  },
//
//  setMessage: function(msg) {
//    this.body.update(msg);
//  },
//
//  afterShow: function() {
//    Ext.ux.Notify.window.superclass.afterShow.call(this);
//    if(this.autoHide) { this.task.delay(this.hideDelay || 5000); }
//    Ext.fly(this.body.dom).on('click', function() {
//      this.task.cancel();
//      this.hide();
//    }, this);
//  },
//
//  animShow: function() {
//    this.pos = 0;
//    while(Ext.ux.NotifyMgr.positions.indexOf(this.pos)>-1) {
//      this.pos++;
//    }
//    Ext.ux.NotifyMgr.positions.push(this.pos);
//
//    this.setSize(300, 100);
//    this.el.alignTo(document, 't-t', [ 0, 10 + ((this.getSize().height+10) * this.pos) ]);
//
//    this.el.slideIn('t', { duration: 1, callback:this.afterShow, scope: this }); //.pause(5).ghost('t', { remove: true });
//  },
//
//  animHide: function() {
//    Ext.ux.NotifyMgr.positions.remove(this.pos);
//
//    this.el.ghost('t', {
//      duration: 1,
//      remove: true
//    });
//  },
//
////  onRender: function(ct, position) {
////    Ext.ux.Notify.window.superclass.onRender.call(this, ct, position);
////  },
//
//  onDestroy: function() {
//    Ext.ux.NotifyMgr.positions.remove(this.pos);
//    Ext.ux.Notify.window.superclass.onDestroy.call(this);
//  },
//
//  focus: Ext.emptyFn
//});

