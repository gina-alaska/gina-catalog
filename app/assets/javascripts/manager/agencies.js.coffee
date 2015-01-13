# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load',  ->
  agenciestypehead = new TypeAheadField('[data-behavior="typeahead"][data-name="agencies"]', {
    display_key: (d) ->
      "#{d.name} (#{d.acronym})"
  })
  agenciestypehead.on 'typeahead:selected', (e, suggestion, dataset) ->
    target = this
    $(target).data('suggestion', suggestion)
    $('#add-selected-agency').removeClass('disabled')
    $('#add-selected-agency').removeClass('btn-info')
    $('#add-selected-agency').addClass('btn-success')
    
  agenciestypehead.on 'keyup', -> 
    if $(this).val() == ""
      target = this
      $(target).data('suggestion', "")
      $('#add-selected-agency').removeClass('btn-success')
      $('#add-selected-agency').addClass('disabled')
      $('#add-selected-agency').addClass('btn-info')

$(document).on 'nested:fieldAdded:entry_agencies', (e) ->
  suggestion = $('#agency_search').data('suggestion')
  return unless suggestion?

  e.field.parents('form').data('dirty', true)  
  e.field.find('.agency_id').val(suggestion.id)
  e.field.find('.agency_name').html(suggestion.name)
  $('#agency_search').val('')
  $('#agency_search').data('suggestion', null)
  $('#add-selected-agency').addClass('disabled')
  $('#add-selected-agency').addClass('btn-info')
