//= require 'jquery'
//= require 'jquery_ujs'
//= require 'jquery.markitup'
//= require 'jquery.slugify'
//= require 'bootstrap'
//= require 'jquery-file-upload/jquery.ui.widget'
//= require 'jquery-file-upload/jquery.fileupload'
//= require 'jquery-file-upload/jquery.iframe-transport'
//= require 'jquery-file-upload/tmpl.min'
//= require 'select2/select2.min'
//= require 'gina-map-layers/gina-openlayers'
//= require 'gina-map-layers/projections/epsg_3338'
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