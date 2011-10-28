Ext.define('Ext.gina.NavigationHandler', {
  extend: 'Ext.Component',

  /**
   * @cfg {Hash} page actions
   * A hash of page actions base from the loaded configuration
   */
  actions: {},
  
  config: {
    /**
     * @cfg {Hash} pages
     * A hash of page configurations to load custom navigation links
     */
    pages: {},

    /**
     * @cfg {Boolean} autoStart
     * Autostart the monitor the changes to the location hash
     */
    autoStart: true,

    /* //protected
     * Function to be implemented by NavigationHandler subclasses, it is empty by default.
     */
    initComponent: Ext.emptyFn,

    /* //protected
     * Monitor for the location hash changes
     */
    monitor: null,

    /*
     * @cfg {Integer}
     * The delay in milliseconds between checks for changes in location.hash
     */
    monitorDelay: 200,

    /**
     * @cfg {String}
     * String used to seperate the key from the value in params
     **/
    paramSeparator: '='
  },
  
  constructor: function(config){
    this.initConfig(config);
    this.callParent();
  },

  initComponent: function() {
    this.addEvents(
      /**
       * @event load
       * Fires after the page is loaded
       */
      'load',

      /**
       * @event start
       * Fires after the location.hash monitor has been started
       */
      'start',

      /**
       * @event stop
       * Fires after the location.hash monitor has been stopped
       */
      'stop',

      /**
       * @event change
       * Fires after the location hash has changed
       */
      'change');

    this.callParent(arguments);

    if(Ext.isIE && !Ext.isIE6) {
      var ihistory = Ext.core.DomHelper.append(Ext.getBody(), '<iframe id="iHistory" style="display:none"></iframe>');
      var iframe = ihistory.contentDocument || ihistory.contentWindow.document;
      iframe.open();
      iframe.close();
      iframe.location.hash = top.location.hash.replace(/^#[\/]{0,1}/,'');
    }

    if (this.getAutoStart()) {
      if (!Ext.isReady) {
        Ext.onReady(this.start, this);
      } else {
        this.start();
      }
    }
  },

  /* //protected
   * Monitor handler function that watches for changes to the location.hash
   */
  monitorHandler: function() {
    this.open(this.getHash());
  },

  /**
   * Start monitoring the location.hash for changes
   */
  start: function() {
    this.monitor = setInterval(Ext.bind(this.monitorHandler, this), this.getMonitorDelay());
    this.fireEvent('start', this);
  },

  /**
   * Stop monitoring the location.hash for changes
   */
  stop: function() {
    clearInterval(this.monitor);
    this.fireEvent('stop', this);
  },

  /**
   * Get the current location.hash, '#' hash been stripped from the hash
   * @return {String}
   */
  getHash: function() {
    if (Ext.isIE && !Ext.isIE6) {
      var ihistory = Ext.getDom('iHistory');
      var iframe = ihistory.contentDocument || ihistory.contentWindow.document;

      var iframeHash = iframe.location.hash.replace(/^#[\/]{0,1}/, '');
      var hash = top.location.hash.replace(/^#[\/]{0,1}/, '');

      if(this.current_page == hash && this.iframeHash != iframeHash) {
        this.setHash(iframeHash);
        this.iframeHash = iframeHash;
        return iframeHash;
      }
    }
    return top.location.hash.replace(/^#[\/]{0,1}/, '');
  },

  getPage: function(page) {
    return this.getPages()[page];
  },

  getActions: function() {
    var collection = [],
        page;

    Ext.each(arguments, function(item) {
      page = this.getPage(item);
      if(page) {
        if(!this.actions[item]) {
          this.actions[item] = new Ext.Action({
            text: page.text || '',
            scope: this,
            handler: page.actionHandler || function() { this.load('#'+item, true); },
            hidden: !page.active
          });
        }
        collection.push(this.actions[item]);
      }
    }, this);
    return collection;
  },

  getRequest: function(hash) {
    if(!hash) { hash = this.getHash(); }
    var request = this.decodeHash(hash);
    return request;
  },

  updateHistory: function(hash) {
    if (Ext.isIE) {
      var ihistory = Ext.getDom('iHistory');
      var iframe = ihistory.contentDocument || ihistory.contentWindow.document;
      if (iframe.location.hash != hash) {
        iframe.open();
        iframe.close();
        iframe.location.hash = hash;
      }
    }
  },

  /**
   * Set the location.hash
   * @param {String} hash
   */
  setHash: function(hash) {
    if (!Ext.isIE && hash[0] != '#') { hash = '#' + hash; }
    top.location.hash = hash;
  },

  buildHash: function(controller, action, params) {
    var hash = '';
    for(var key in params) {
      if(key) {
        if(hash !== '') { hash +=  '&'; }
        else { hash = '?' }
        hash += key + this.getParamSeparator() + params[key];
      }
    }
    return '#' + controller + '/' + action + hash;
  },

  decodeHash: function(hash) {
    var request = {}, parts;

    if(hash && hash[0] == '#') {
      hash = hash.replace(/^#[\/]{0,1}/, '');
    }
    if(!hash) { hash = ''; }


    request.hash = hash;
    if(request.hash.indexOf('?') >= 0) {
      parts = request.hash.split('?');
    } else {
      parts = [request.hash, ''];
    }
    var controller_and_action = parts[0].split('/');

    request.host = top.location.host;
    request.subdomains = request.host.split('.');
    request.controller = controller_and_action.shift() || this.defaultPage;
    request.action = controller_and_action.shift() || 'index';
    request.id = controller_and_action.shift();
    request.params = Ext.urlDecode(parts[1]);//.split('&');

    if (request.id) {
      request.params.id = request.id;
    }
    return request;
  },

  quickLoad: function(controller, action, params, force) {
    params = params || {};
    force = (force == undefined ? true : force);
    this.load(this.buildHash(controller, action, params), false, force);
  },

  load: function(hash, forceUrl, forceHandler) {
    if (forceUrl === true) { this.forceLoadUrl = true; }
    if (forceHandler === true) { this.forceLoadHandler = true; }
    this.setHash(hash);
  },

  loadRequest: function(request) {
    var hash = this.buildHash(request.controller, request.action, request.params);
    this.load(hash, request.forceUrl, request.forceHandler);
  },

  setHandler: function(controller, handler) {
    var page = this.getPage(controller);
    page.handler = handler;
  },

  runHandler: function(page, request, from_url) {
    if (page && page.handler && Ext.isReady) {
//      try {
        page.handler(request, from_url);
//      } catch(err) {
//        if(console && console.log) {
//          console.log('Error running navigation handler function', err)
//        }
//      }
    }
  },

  monitoredAppUrl: function() {
    if(this.appRootUrl)  {
      return top.location.pathname.match(this.appRootUrl)
    }
    return true;
  },

  open: function(hash) {
    if (!this.monitoredAppUrl()) { return false; }

    var request = this.getRequest(hash);
    var page = this.getPage(request.controller);
    if(!page) {
      hash = this.getDefaultPage();
      request = this.getRequest(hash);
      page = this.getPage(request.controller);
    }

    if (page) {
      if (page.url && (this.current_url != page.url || this.forceLoadUrl === true)) {
        switch(page.mode) {
          case 'redirect':
            top.document.location = page.url;
            break;
          default:
            var cfg = Ext.applyIf({
              url: page.url,
              scope: this,
              success: function(xhr, options){
                Ext.gina.Ajax.success(xhr, options, this.manager);
                this.runHandler(page, request, true);
              },
              failure: function(xhr, options){
                Ext.gina.Ajax.failure(xhr, options, this.manager);
              }
            }, Ext.gina.Ajax.defaults);

            Ext.Ajax.request(cfg);
        }
      } else {
        if (this.current_page != hash || this.forceLoadHandler === true) {
          this.runHandler(page, request, false);
        }
      }
      //this.fireEvent('load', request.hash, page);
    }

    if((page && page.url && this.current_url != page.url) ||
            this.current_page != request.hash || this.forceLoadUrl || this.forceLoadHandler) {
      this.onChange(request, page);
    }
  },

  onChange: function(request, page) {
    if(page) { this.current_url = page.url || ''; }
    this.current_page = request.hash;
    this.forceLoadUrl = false;
    this.forceLoadHandler = false;

    this.updateHistory(request.hash);
    this.fireEvent('change', this, request, page);
  },

  toolbarItems: function(pages, seperator) {
    if(!pages) { pages = []; }

    var buttons = [];
    Ext.each(pages, function(name) {
      var page = this.getPage(name);
      if(page) {
        buttons.push({
          text: page.title || 'Unknown Button Name',
          icon: page.icon || '',
          scope: this,
          handler: function() {
            switch(page.mode) {
              case "window":
                var win = window.open(page.url);
                break;
              default:
                if (page.url) {
                  top.location = page.url;
                } else if (page.handler) {
                  page.handler.call(page.scope || window);
                } else {
                  this.load(name, true, true);
                }
                break;
            }
          }
        });

        //Add a button seperator is requested
        if(seperator) { buttons.push(seperator); }
      } else {
        buttons.push(name);
      }
    }, this);

    return buttons;
  }
});