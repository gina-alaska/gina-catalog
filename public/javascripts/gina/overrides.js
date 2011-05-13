Ext.override(Ext.data.HttpProxy, {
  request: function(action, rs, params, reader, callback, scope, options) {
    if (this.conn && reader) {
      this.conn.headers = this.conn.headers || {};

      if (this.conn.headers.hasOwnProperty('Accept') == false)
      {
          if (reader instanceof Ext.data.JsonReader)
              this.conn.headers['Accept'] = 'application/json';
          if (reader instanceof Ext.data.XmlReader)
              this.conn.headers['Accept'] = 'application/xml';
      }
    }

    Ext.data.HttpProxy.superclass.request.apply(this, arguments);
}
});