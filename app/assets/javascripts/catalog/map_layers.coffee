# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready turbolinks:load',  ->
  maplayerstypehead = new TypeAheadField('[data-behavior="typeahead"][data-name="map_layer"]', {
    display_key: (d) ->
      "#{d.name}"
  })
  maplayerstypehead.on 'typeahead:selected', (e, suggestion, dataset) ->
    target = this
    $(target).data('suggestion', suggestion)
    $('#add-selected-map-layer').removeClass('disabled')
    $('#add-selected-map-layer').removeClass('btn-info')
    $('#add-selected-map-layer').addClass('btn-success')

  maplayerstypehead.on 'keyup', ->
    if $(this).val() == ""
      target = this
      $(target).data('suggestion', "")
      $('#add-selected-map-layer').removeClass('btn-success')
      $('#add-selected-map-layer').addClass('disabled')
      $('#add-selected-map-layer').addClass('btn-info')

$(document).on 'nested:fieldAdded:entry_map_layers', (e) ->
  suggestion = $('#map_layer_search').data('suggestion')
  return unless suggestion?

  e.field.parents('form').data('dirty', true)
  e.field.find('.map_layer_id').val(suggestion.id)
  e.field.find('.map_layer_name').html(suggestion.name)
  e.field.find('.map_layer_type').html(suggestion.type)
  e.field.find('.map_layer_map_url').html(suggestion.map_url)
  $('#map_layer_search').val('')
  $('#map_layer_search').data('suggestion', null)
  $('#add-selected-map-layer').addClass('disabled')
  $('#add-selected-map-layer').addClass('btn-info')

# This function is used in two places catalog/map_layer/_entries.html.haml and catalog/entries/_map_layers_tab.html.haml
$(document).on 'map_layers:refresh', ->
  $.get( document.location ).done (data) ->
    layers = $(data).find('#map-layer-table')
    $('#map-layers-container').html(layers)
    $('form[data-behavior="confirm-unsaved-changes"]').data("dirty", true)

$(document).on 'change', '[data-toggle="hidden"]', ->
  target = $(this).data('target')
  match = $(this).data('match')

  if $(this).val() == match
    $(target).removeClass('hidden')
  else
    $(target).addClass('hidden')
