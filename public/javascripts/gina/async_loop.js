/**
 * Async loop handler, iterates over a large array or collection of some sort without
 * causing the browser to lock-up due to cpu usage.
 *
 * This is much slower than using a normal Ext.each loop as a slight delay is
 * caused between each iteration
 *
 * Example:
 *
 * Ext.ux.each([1,2,3,4,5,6], {
 *  scope: this,
 *  handler: function(item) {
 *    console.log(item);
 *  }
 *  onComplete: function() {
 *    console.log('The loop has finished!');
 *  }
 * });
 */
Ext.ux.Iterator = new function() {
  this.taskrunner = new Ext.util.TaskRunner(0.0000000000001);

  this.objType = function(obj) {
    if(typeof(obj) == 'object') {
      if(obj.getAt)
        return 'store';
      if(obj.get)
        return 'mixedcollection';
      if(obj.length)
        return 'array';
    }
    return typeof(obj);
  };

  /**
   * Actual looping handler
   *
   * @param items - List of items to iterate over, can be an Array, MixedCollection or Store
   * @param opts - additional options for handler, takes  params for scope, handler and onComplete
   */
  this.each = function(items, opts) {
    var total, percent, lastPercent;

    switch(this.objType(items)) {
      case 'array':
        total = items.length;
        break;
      case 'store':
        total = items.getCount();
        break;
      case 'mixedcollection':
        total = items.length;
        break;
    }

    opts = opts || {};
    Ext.applyIf(opts, {
      scope: this,
      index: 0,
      total: total,
      percent: 0,
      lastPercent: 0,
      progress: true,
      handler: Ext.emptyFn
    });

    /* kill any other async loopers */
    if(opts.exclusive === true) {
      this.taskrunner.stopAll();
    }

    if(opts.progress === true) {
      opts.progress = Ext.Msg.show({
        title: opts.progress_title || '',
        minWidth: 300,
        msg: opts.progress_msg || 'Loading...',
        progress: true,
        modal: false
      });
    }

    var task = {
      run: function(opts) {
        var item;

        switch(this.objType(items)) {
          case 'array':
            item = items[opts.index];
            break;
          case 'store':
            item = items.getAt(opts.index);
            break;
          case 'mixedcollection':
            item = items.get(opts.index);
            break;
        }

        if(item === undefined) {
          this.taskrunner.stop(task);
          if (opts.onComplete) {
            opts.onComplete.call(opts.scope);
          }
          
          if(opts.progress) { opts.progress.hide(); }
          return true;
        } else {
          opts.handler.apply(opts.scope, [item, opts]);
        }

        if(opts.progress) {
          opts.percent = Math.ceil(opts.index / opts.total * 100);
          if(opts.percent > opts.lastPercent) {
            opts.progress.updateProgress(opts.index / opts.total);
            opts.lastPercent = opts.percent;
          }
        }
        opts.index += 1;
      }.createDelegate(this, [opts]),
      interval: 0.0000000000001
    }
    this.taskrunner.start(task);
  }
}();
Ext.ux.each = Ext.ux.Iterator.each.createDelegate(Ext.ux.Iterator);