# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'map_layers:refresh', -> 
  $.get( document.location ).done (data) ->
    layers = $(data).find('#map_layer_list')
    $('#map-layers .fields').html(layers)
    $('form[data-behavior="confirm-unsaved-changes"]').data("dirty", true)
