//= require 'jquery'
//= require 'jquery_ujs'
//= require 'jquery.markitup'
//= require 'jquery.slugify'
//= require 'jquery.ui.sortable'
//= require 'nested_sortable'
//= require 'bootstrap'
//= require 'fileupload/bootstrap-fileupload'
//= require 'select2/select2.min'
//= require 'markitup'
//= require 'manager/pages'
//= require bootstrap-datepicker
//= require jquery_nested_form
//= require 'gina-map-layers/gina-openlayers'
//= require 'gina-map-layers/projections/all'
//= require 'projections'
//= require 'maps'
//= require 'location_editor'
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