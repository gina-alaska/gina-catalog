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
  setTimeout(function() { 
    $('.carousel').carousel({
      interval: $('.carousel').data('interval')
    }); 
  }, $('.carousel').data('start-delay') || 5000);
  
  $(document).on("click", '[data-behaviour="stash"]', function(evt) {
    evt.preventDefault();
    var target = $(this).data("target");
    var value = $(this).data("value");
    $(target).val(value);
    $(target).parents("form").submit();
  });
  
  $("[data-behaviour='load_collection']").on("click", function(){
    var target = $(this).data("target");
    if($(target).val() == $(this).data("value")) {
      $(target).val('');
      $(target).parents("form").submit();
    } else {
      $(target).val($(this).data("value"));
      $(target).parents("form").submit();
    }
  });
  
  $(document).on('click', '[data-action="scroll"]', function(evt) {
    evt.preventDefault();
    var target = $(evt.currentTarget).attr('href');
    if(!target) { target = $(evt.currentTarget).data('target'); }
    
    if (target) { 
      var parent = $('body');
      var cur_scroll = parent.scrollTop();
      parent.animate({
        scrollTop: $(target).offset().top
      });
    }
  });
  
  $('a.goto-top').hide();
  $(window).scroll(function() {
    var pos = $(window).scrollTop();
    if(pos > 50) { 
      $('a.goto-top').fadeIn();
    } else {
      $('a.goto-top').fadeOut();
    }
  });
})

$.fn.animateHighlight = function(highlightColor, duration) {
    var highlightBg = highlightColor || "#FFFF9C";
    var animateMs = duration || 1500;
    var originalBg = this.css("backgroundColor");
    this.stop().css("background-color", highlightBg).animate({backgroundColor: originalBg}, animateMs);
};