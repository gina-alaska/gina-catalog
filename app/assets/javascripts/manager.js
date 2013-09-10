//= require 'jquery'
//= require 'jquery_ujs'
//= require 'jquery.history'
//= require 'jquery.slugify'
//= require 'jquery.ui.sortable'
//= require 'nested_sortable'
//= require 'bootstrap'
//= require 'fileupload/bootstrap-fileupload'
//= require 'select2/select2'
//= require 'manager/pages'
//= require bootstrap-datepicker
//= require 'bootstrap-colorpicker/bootstrap-colorpicker'
//= require jquery_nested_form
//= require 'gina-map-layers/gina-openlayers'
//= require 'gina-map-layers/projections/all'
//= require 'projections'
//= require 'openlayers_map'
//= require 'editor_map'
//= require 'catalog_map'
//= require 'location_editor'
//= require 'ace_editor'
//= require 'flash_message'
//= require 'history'
//= require 'spin'
//= require_self

$(document).ready(function() {
  $(document).on('click', '#catalog-items tr[data-toggle="collapse"] label, #catalog-items tr[data-toggle="collapse"] a, #catalog-items tr[data-toggle="collapse"] input[type="checkbox"]', function(e) {
    e.stopPropagation();
  });
  $(document).on('click', '[data-action="expand-all"]', function() {
    $($(this).data('target')).collapse('show');
  });
  $(document).on('click', '[data-action="collapse-all"]', function() {
    $($(this).data('target')).collapse('hide');
  });
  $('select[data-ui="select2"]').select2({ allowClear: true, width:'copy' })
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(document).on('click', '[data-disabled]', function(evt) {
  evt.preventDefault();
});
