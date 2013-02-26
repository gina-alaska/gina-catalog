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
//= require 'markitup'
//= require 'manager/pages'
//= require_self

$(document).ready(function() {
  $(document).on('click', '#catalog-items tr[data-toggle="collapse"] label, #catalog-items tr[data-toggle="collapse"] > a, #catalog-items tr[data-toggle="collapse"] > input[type="checkbox"], #catalog-items tr[data-toggle="collapse"] > input', function(e) {
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