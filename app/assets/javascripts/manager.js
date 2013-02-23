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
  $('[data-action="expand-all"]').on('click', function() {
    $($(this).data('target')).collapse('show');
  });
  $('[data-action="collapse-all"]').on('click', function() {
    $($(this).data('target')).collapse('hide');
  });
})