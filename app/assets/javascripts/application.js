//= require 'jquery'
//= require 'jquery_ujs'
//= require 'jquery.markitup'
//= require 'jquery.slugify'
//= require 'jquery.ui.effect-highlight'
//= require 'bootstrap'
//= require 'jquery-file-upload/jquery.ui.widget'
//= require 'jquery-file-upload/jquery.fileupload'
//= require 'jquery-file-upload/jquery.iframe-transport'
//= require 'jquery-file-upload/tmpl.min'
//= require 'select2/select2.min'
//= require 'gina-map-layers/gina-openlayers'
//= require 'gina-map-layers/projections/all'
//= require 'projections'
//= require 'maps'
//= require_self


$(document).ready(function(){
  $("[data-behaviour='load_collection']").on("click", function(){
    var target = $(this).data("target");
    if($(target).val() == $(this).data("value")) {
      $(target).val('');
      $(target).parents("form").submit();
    } else {
      $(target).val($(this).data("value"));
      $(target).parents("form").submit();
    }
  })
})

$.fn.animateHighlight = function(highlightColor, duration) {
    var highlightBg = highlightColor || "#FFFF9C";
    var animateMs = duration || 1500;
    var originalBg = this.css("backgroundColor");
    this.stop().css("background-color", highlightBg).animate({backgroundColor: originalBg}, animateMs);
};