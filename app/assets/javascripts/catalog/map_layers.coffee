# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load',  ->
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