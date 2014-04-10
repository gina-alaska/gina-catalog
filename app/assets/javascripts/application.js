//= require 'jquery'
//= require 'jquery_ujs'
//= require 'jquery.slugify'
//= require 'jquery.history'
//= require 'jquery.ui.effect-highlight'
//= require 'jquery.ui.effect-slide'
//= require 'bootstrap'
//= require 'jquery-file-upload/jquery.ui.widget'
//= require 'jquery-file-upload/jquery.fileupload'
//= require 'jquery-file-upload/jquery.iframe-transport'
//= require 'jquery-file-upload/tmpl.min'
//= require 'select2/select2'
//= require 'gina-map-layers/adapters/openlayers'
//= require 'gina-map-layers/projections/all'
//= require 'spin'
//= require 'projections'
//= require 'maps/openlayers_map'
//= require 'maps/catalog_map'
//= require 'maps/record_map'
//= require 'maps/map_layers'
//= require 'catalogs'
//= require 'flash_message'
//= require 'pages'
//= require 'history'
//= require 'catalog_search'
//= require 'notifications'
//= require_self


var initialize_page = function(){
  setTimeout(function() {
    $('.carousel').carousel({
      interval: $('.carousel').data('interval')
    });
  }, $('.carousel').data('start-delay') || 5000);

  $('a.goto-top').hide();

  // var features, map = $('#map').data('map').map;
  //   map.addControl(new OpenLayers.Control.MousePosition({ displayProjection: 'EPSG:4326', numDigits: 3 }));
  //   #{ build_result_layer('map', @results) }
  // }

  // $(document).on('ready', add_search_features);
  // $(document).on('page:change', add_search_features);
  $('select[data-ui="select2"]').select2({ allowClear: true, width:'copy' })

  $('.collapse').on('show', function() {
    var icon = $(this).parents('.result').find('i.collapse-icon');
    icon.removeClass('icon-chevron-down');
    icon.addClass('icon-chevron-up');
  });
  $('.collapse').on('hide', function() {
    var icon = $(this).parents('.result').find('i.collapse-icon');
    icon.removeClass('icon-chevron-up');
    icon.addClass('icon-chevron-down');
  });
};

$(document).ready(initialize_page);
// $(document).on('page:change', initialize_page);

$(document).on('click', '[data-disabled]', function(evt) {
  evt.preventDefault();
  evt.stopPropagation();
});

$(document).on('click', '[data-action="scroll"]', function(evt) {
  evt.preventDefault();
  var target = $(this).attr('href');
  if(!target) { target = $(this).data('target'); }
  if (target) {
    var parent = $('body,html');
    var cur_scroll = parent.scrollTop();
    parent.animate({
      scrollTop: $(target).offset().top
    });
  }
});

$(document).on('ajax:beforeSend', function(event, xhr, settings) {
  $('.spinner-container').spin('large');
  // /* Update the history */
  // // if (history && history.pushState) {
  //   console.log(settings);
  //   History.pushState({ ajax: true }, 'ajax request',  settings.url)
  //   event.preventDefault();
  //   xhr.abort();
  // // }
});

$(document).on('ajax:complete', function() {
  $('.spinner-container').spin(false)
});

$(window).scroll(function() {
  var pos = $(window).scrollTop();
  if(pos > 50) {
    $('a.goto-top').fadeIn();
  } else {
    $('a.goto-top').fadeOut();
  }
});
$.fn.animateHighlight = function(highlightColor, duration) {
    var highlightBg = highlightColor || "#FFFF9C";
    var animateMs = duration || 1500;
    var originalBg = this.css("backgroundColor");
    this.stop().css("background-color", highlightBg).animate({backgroundColor: originalBg}, animateMs);
};
