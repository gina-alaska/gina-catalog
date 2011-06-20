/**
 * ContextMenu plugin for treepanels and grids.  This plugin allows you to
 * define a menu that will automatically show for when a context click happens
 * on a tree node or grid row.
 *
 * Multiple menus can be defined for each context click, switching between them is done
 * using activateMenu function.  When combined with the beforeShow action this can also
 * inspect the currently selected node to determine on the fly what menu to show.
 *
 * Refer to the contextmenu event in the treepanel and/or gridpanel to see what parameters
 * the handlers receive, they will be different for each component.
 *
 * <code>
 * var ctxMenu = new Ext.ux.ContextMenu({
 *   "menus": {
 *     "default": [{
 *       "text": "New Folder"
 *       "handler": function() {
 *         alert("Create a new folder!");
 *     }, {
 *       "text": "Delete Folder"
 *       "handler": function() {
 *         alert("Delete a folder!");
 *       }]
 *     }],
 *     "root": [{
 *       "text": "New Folder"
 *       "handler": function() {
 *         alert("Create a new folder!");
 *     }]
 *   },
 *   "listeners": {
 *     beforeShow: function(plugin, type, node) {
 *       //Tree?
 *       if(type == 'tree') {
 *         if (node.getDepth() > 0) { plugin.activateMenu('default'); }
 *         else { plugin.activateMenu('root'); }
 *       }
 *     }
 *   }
 * })
 * </code>
 *
 * @param config
 */
Ext.ux.ContextMenu = function(config) {
  config = config || {};
  this.initialConfig = config;
  this.events = [];
  this.listeners = config.listeners || {};
  //Ext.apply(this, config);

  Ext.ux.ContextMenu.superclass.constructor.call(this);

  this.addEvents('beforeshow');

  Ext.apply(this, config, {
    defaultMenu: 'default',
    menus: [],
    actions: {}
  });

  for(var ii in this.menus) {
    this.menus[ii] = new Ext.menu.Menu({
      items: config.menus[ii]
    });
  }

  /**
   * Makes the passed in menu active for context clicks
   * If no id is given then it activates the "default" menu
   *
   * @param id - Id of the menu to show for contextmenu events, if not called then the menu named "default"
   *             will be shown
   */
  this.activateMenu = function(id) {
    if(id) {
      this.activeMenu = this.menus[id];
    } else {
      this.activeMenu = this.menus[this.defaultMenu];
    }
  };

  /**
   * Call back function to handle context menu clicks for treepanels
   *
   * @param node
   * @param e
   */
  this.showTreeContextMenu = function(node, e) {
    if (this.fireEvent('beforeshow', this, 'tree', node) !== false) {
      node.select();
      e.ctxNode = node;
      this.activeMenu.showAt(e.getXY());
    }
  };

  /**
   * Callback function to handle context menu clicks for gridpanels
   *
   * @param grid
   * @param index
   * @param e
   */
  this.showContextMenu = function(grid, index, e) {
    var sm = grid.getSelectionModel();
    sm.selectRow(index);
    var record = sm.getSelected();

    if (this.fireEvent('beforeshow', this, 'grid', record) !== false) {
      e.ctxRecord = record;
      e.ctxPanel = grid;
      this.activeMenu.showAt(e.getXY());
      e.stopEvent();
    }
  };

  /**
   * Callback function to handle context menu clicks for dataviews
   *
   * @param DataView
   * @param Number index
   * @param node
   * @param Event e
   */
  this.showDataviewContextMenu = function(dv, index, node, e) {
    var records = dv.getSelectedRecords();
    if(this.fireEvent('beforeshow', this, 'dataview', records) !== false) {
      if(records.indexOf(dv.getRecord(node)) < 0 && this.forceSelection) {
        dv.select(index);
        records = dv.getSelectedRecords();
      }

      e.ctxRecords = records;
      e.ctxPanel = dv;
      this.activeMenu.showAt(e.getXY());
      e.stopEvent();
    }
  };

  /**
   * General plugin init function, currently only implements support for trees and grids
   * 
   * @param panel
   */
  this.init = function(panel) {
    /* Activate the default menu */
    this.activateMenu();

    if(panel.isXType('treepanel')) {
      panel.on('contextmenu', this.showTreeContextMenu, this)
    } else if(panel.isXType('grid')) {
      panel.on('rowcontextmenu', this.showContextMenu, this)
    } else if(panel.isXType('dataview')) {
      panel.on('contextmenu', this.showDataviewContextMenu, this);
    }
  };
};
Ext.extend(Ext.ux.ContextMenu, Ext.util.Observable);