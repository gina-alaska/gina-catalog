Ext.define('App.controller.Catalog', {
  extend: 'Ext.app.Controller',

  stores: ['Catalog', 'Filters'],

  refs: [{
    ref: 'catalogList',
    selector: 'catalog_list'
  }],

  init: function() {
    this.control({
      /* Main viewport events */
      'viewport > #center': {
        render: this.start
      },
      'viewport > #center button[text="Catalog"]': {
        click: this.show
      },
      'catalog_list': {
        itemcontextmenu: this.showContextMenu
      },
      '#catalog_list_menu menuitem[action="edit_record"]': {
        click: function() {
          var selected = this.getCatalogList().getSelectionModel().getSelection()[0];
          if(selected) {
            window.open('/manager#' + selected.get('type').toLowerCase() + '/' + selected.get('id'));            
          } else {
            Ext.gina.Notify.show('error', 'No record was selected');
          }
        }
      }
    });
  },

  show: function() {
    var panel = this.catalogPanel.up('panel');
    panel.getLayout().setActiveItem(this.catalogPanel);

    if(App.current_user.loaded && !App.current_user.isLoggedIn()) {
      this.showSplash();
    } else {
      App.current_user.on('logged_out', this.showSplash, this, { single: true });
    }

    // this.getStore('Catalog').on('beforeload', this.updateFilters, this);
    if(!this.loaded) {
      Ext.defer(function() { this.getStore('Catalog').load(); }, 300, this);
      this.loaded = true;
    }
  },

  showSplash: function() {
	  if(!this.splash) {
     	this.splash = Ext.widget('catalog_splash');	    
	  }
    this.getStore('Catalog').on('load', this.splash.recordsLoaded, this.splash, { single: true });
    this.on('featuresrendered', this.splash.featuresRendered, this.splash);   
    this.splash.show();
  },
  
  start: function(panel) {
    this.catalogPanel = panel.add({
      itemId: 'catalog',
      layout: 'border',
      border: false,
      defaults: { border: false },
      items: [{
        region: 'west',
        width: 500,
        margin: '3px',
        // style: 'border-width: 1px; border-style: solid;',
        split: true,
        xtype: 'catalog_sidebar',
        store: this.getStore('Catalog')
      }, {
        region: 'center',
        xtype: 'catalog_map',
        dockedItems: [{
          dock: 'bottom',
          xtype: 'catalog_maptoolbar'
        }]
      }]
    });
    // this.show();
  },

  createContextMenu: function() {
    this.contextMenu = new Ext.menu.Menu({
      itemId: 'catalog_list_menu',
      items: [{ text: 'Edit', action: 'edit_record' }]
    });
  },

  showContextMenu: function(view,record,item, index, e){
    var roles = App.current_user.get('roles');

    if(roles && (roles.indexOf('admin') >= 0 || roles.indexOf('manager') >= 0)) {
      if(!this.contextMenu) { this.createContextMenu(); }
      view.select(record);
      this.contextMenu.showAt(e.getXY()); 
      e.stopEvent();      
    }
  }
});