(function(t, e) {
  if (typeof exports == "object") module.exports = e();
  else if (typeof define == "function" && define.amd) define(e);
  else t.Spinner = e()
})(this, function() {
  "use strict";
  var t = ["webkit", "Moz", "ms", "O"],
    e = {},
    i;

  function o(t, e) {
    var i = document.createElement(t || "div"),
      o;
    for (o in e) i[o] = e[o];
    return i
  }
  function n(t) {
    for (var e = 1, i = arguments.length; e < i; e++) t.appendChild(arguments[e]);
    return t
  }
  var r = function() {
      var t = o("style", {
        type: "text/css"
      });
      n(document.getElementsByTagName("head")[0], t);
      return t.sheet || t.styleSheet
    }();

  function s(t, o, n, s) {
    var a = ["opacity", o, ~~ (t * 100), n, s].join("-"),
      f = .01 + n / s * 100,
      l = Math.max(1 - (1 - t) / o * (100 - f), t),
      d = i.substring(0, i.indexOf("Animation")).toLowerCase(),
      u = d && "-" + d + "-" || "";
    if (!e[a]) {
      r.insertRule("@" + u + "keyframes " + a + "{" + "0%{opacity:" + l + "}" + f + "%{opacity:" + t + "}" + (f + .01) + "%{opacity:1}" + (f + o) % 100 + "%{opacity:" + t + "}" + "100%{opacity:" + l + "}" + "}", r.cssRules.length);
      e[a] = 1
    }
    return a
  }
  function a(e, i) {
    var o = e.style,
      n, r;
    if (o[i] !== undefined) return i;
    i = i.charAt(0).toUpperCase() + i.slice(1);
    for (r = 0; r < t.length; r++) {
      n = t[r] + i;
      if (o[n] !== undefined) return n
    }
  }
  function f(t, e) {
    for (var i in e) t.style[a(t, i) || i] = e[i];
    return t
  }
  function l(t) {
    for (var e = 1; e < arguments.length; e++) {
      var i = arguments[e];
      for (var o in i) if (t[o] === undefined) t[o] = i[o]
    }
    return t
  }
  function d(t) {
    var e = {
      x: t.offsetLeft,
      y: t.offsetTop
    };
    while (t = t.offsetParent) e.x += t.offsetLeft, e.y += t.offsetTop;
    return e
  }
  var u = {
    lines: 12,
    length: 7,
    width: 5,
    radius: 10,
    rotate: 0,
    corners: 1,
    color: "#000",
    direction: 1,
    speed: 1,
    trail: 100,
    opacity: 1 / 4,
    fps: 20,
    zIndex: 2e9,
    className: "spinner",
    top: "auto",
    left: "auto",
    position: "relative"
  };

  function p(t) {
    if (typeof this == "undefined") return new p(t);
    this.opts = l(t || {}, p.defaults, u)
  }
  p.defaults = {};
  l(p.prototype, {
    spin: function(t) {
      this.stop();
      var e = this,
        n = e.opts,
        r = e.el = f(o(0, {
          className: n.className
        }), {
          position: n.position,
          width: 0,
          zIndex: n.zIndex
        }),
        s = n.radius + n.length + n.width,
        a, l;
      if (t) {
        t.insertBefore(r, t.firstChild || null);
        l = d(t);
        a = d(r);
        f(r, {
          left: (n.left == "auto" ? l.x - a.x + (t.offsetWidth >> 1) : parseInt(n.left, 10) + s) + "px",
          top: (n.top == "auto" ? l.y - a.y + (t.offsetHeight >> 1) : parseInt(n.top, 10) + s) + "px"
        })
      }
      r.setAttribute("role", "progressbar");
      e.lines(r, e.opts);
      if (!i) {
        var u = 0,
          p = (n.lines - 1) * (1 - n.direction) / 2,
          c, h = n.fps,
          m = h / n.speed,
          y = (1 - n.opacity) / (m * n.trail / 100),
          g = m / n.lines;
        (function v() {
          u++;
          for (var t = 0; t < n.lines; t++) {
            c = Math.max(1 - (u + (n.lines - t) * g) % m * y, n.opacity);
            e.opacity(r, t * n.direction + p, c, n)
          }
          e.timeout = e.el && setTimeout(v, ~~ (1e3 / h))
        })()
      }
      return e
    },
    stop: function() {
      var t = this.el;
      if (t) {
        clearTimeout(this.timeout);
        if (t.parentNode) t.parentNode.removeChild(t);
        this.el = undefined
      }
      return this
    },
    lines: function(t, e) {
      var r = 0,
        a = (e.lines - 1) * (1 - e.direction) / 2,
        l;

      function d(t, i) {
        return f(o(), {
          position: "absolute",
          width: e.length + e.width + "px",
          height: e.width + "px",
          background: t,
          boxShadow: i,
          transformOrigin: "left",
          transform: "rotate(" + ~~ (360 / e.lines * r + e.rotate) + "deg) translate(" + e.radius + "px" + ",0)",
          borderRadius: (e.corners * e.width >> 1) + "px"
        })
      }
      for (; r < e.lines; r++) {
        l = f(o(), {
          position: "absolute",
          top: 1 + ~ (e.width / 2) + "px",
          transform: e.hwaccel ? "translate3d(0,0,0)" : "",
          opacity: e.opacity,
          animation: i && s(e.opacity, e.trail, a + r * e.direction, e.lines) + " " + 1 / e.speed + "s linear infinite"
        });
        if (e.shadow) n(l, f(d("#000", "0 0 4px " + "#000"), {
          top: 2 + "px"
        }));
        n(t, n(l, d(e.color, "0 0 1px rgba(0,0,0,.1)")))
      }
      return t
    },
    opacity: function(t, e, i) {
      if (e < t.childNodes.length) t.childNodes[e].style.opacity = i
    }
  });

  function c() {
    function t(t, e) {
      return o("<" + t + ' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">', e)
    }
    r.addRule(".spin-vml", "behavior:url(#default#VML)");
    p.prototype.lines = function(e, i) {
      var o = i.length + i.width,
        r = 2 * o;

      function s() {
        return f(t("group", {
          coordsize: r + " " + r,
          coordorigin: -o + " " + -o
        }), {
          width: r,
          height: r
        })
      }
      var a = -(i.width + i.length) * 2 + "px",
        l = f(s(), {
          position: "absolute",
          top: a,
          left: a
        }),
        d;

      function u(e, r, a) {
        n(l, n(f(s(), {
          rotation: 360 / i.lines * e + "deg",
          left: ~~r
        }), n(f(t("roundrect", {
          arcsize: i.corners
        }), {
          width: o,
          height: i.width,
          left: i.radius,
          top: -i.width >> 1,
          filter: a
        }), t("fill", {
          color: i.color,
          opacity: i.opacity
        }), t("stroke", {
          opacity: 0
        }))))
      }
      if (i.shadow) for (d = 1; d <= i.lines; d++) u(d, -2, "progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)");
      for (d = 1; d <= i.lines; d++) u(d);
      return n(e, l)
    };
    p.prototype.opacity = function(t, e, i, o) {
      var n = t.firstChild;
      o = o.shadow && o.lines || 0;
      if (n && e + o < n.childNodes.length) {
        n = n.childNodes[e + o];
        n = n && n.firstChild;
        n = n && n.firstChild;
        if (n) n.opacity = i
      }
    }
  }
  var h = f(o("group"), {
    behavior: "url(#default#VML)"
  });
  if (!a(h, "transform") && h.adj) c();
  else i = a(h, "animation");
  return p
});

/**
 * Copyright (c) 2011-2013 Felix Gnass
 * Licensed under the MIT license
 */

/*

Basic Usage:
============

$('#el').spin(); // Creates a default Spinner using the text color of #el.
$('#el').spin({ ... }); // Creates a Spinner using the provided options.

$('#el').spin(false); // Stops and removes the spinner.

Using Presets:
==============

$('#el').spin('small'); // Creates a 'small' Spinner using the text color of #el.
$('#el').spin('large', '#fff'); // Creates a 'large' white Spinner.

Adding a custom preset:
=======================

$.fn.spin.presets.flower = {
  lines: 9
  length: 10
  width: 20
  radius: 0
}

$('#el').spin('flower', 'red');

*/

(function(factory) {

  if (typeof exports == 'object') {
    // CommonJS
    factory(require('jquery'), require('spin'))
  } else if (typeof define == 'function' && define.amd) {
    // AMD, register as anonymous module
    define(['jquery', 'spin'], factory)
  } else {
    // Browser globals
    if (!window.Spinner) throw new Error('Spin.js not present')
    factory(window.jQuery, window.Spinner)
  }

}(function($, Spinner) {

  $.fn.spin = function(opts, color) {

    return this.each(function() {
      var $this = $(this),
        data = $this.data();

      if (data.spinner) {
        data.spinner.stop();
        delete data.spinner;
      }
      if (opts !== false) {
        opts = $.extend({
          color: color || $this.css('color')
        }, $.fn.spin.presets[opts] || opts)
        data.spinner = new Spinner(opts).spin(this)
      }
    })
  }

  $.fn.spin.presets = {
    tiny: {
      lines: 8,
      length: 2,
      width: 2,
      radius: 3
    },
    small: {
      lines: 8,
      length: 4,
      width: 3,
      radius: 5
    },
    large: {
      lines: 9, // The number of lines to draw
      length: 0, // The length of each line
      width: 30, // The line thickness
      radius: 41, // The radius of the inner circle
      corners: 1, // Corner roundness (0..1)
      rotate: 56, // The rotation offset
      direction: 1, // 1: clockwise, -1: counterclockwise
      speed: 1.3, // Rounds per second
      trail: 100, // Afterglow percentage
      top: 250
    }
  }
}));