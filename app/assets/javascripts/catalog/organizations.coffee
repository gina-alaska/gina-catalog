# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

OrganizationSuggestion = {
  add: (target, suggestion) ->
    $(target).data('suggestion', suggestion)
    $(target).val(OrganizationSuggestion.display_key(suggestion));
    $('#add-selected-organization').removeClass('disabled')
    $('#add-selected-organization').removeClass('btn-info')
    $('#add-selected-organization').addClass('btn-success')

  display_key: (d) ->
    "#{d.name} (#{d.acronym})"
  }

$(document).on 'ready turbolinks:load',  ->
  organizationstypehead = new TypeAheadField('[data-behavior="typeahead"][data-name="organizations"]', {
    display_key: OrganizationSuggestion.display_key
  })

  organizationstypehead.on 'typeahead:selected', (e, suggestion, dataset) ->
    target = this
    $(document).trigger('organization:suggestion', [target, suggestion])

  organizationstypehead.on 'keyup', ->
    if $(this).val() == ""
      target = this
      $(target).data('suggestion', "")
      $('#add-selected-organization').removeClass('btn-success')
      $('#add-selected-organization').addClass('disabled')
      $('#add-selected-organization').addClass('btn-info')

$(document).on 'organization:suggestion', (e, target, suggestion) ->
  OrganizationSuggestion.add(target, suggestion)

$(document).on 'nested:fieldAdded:entry_organizations', (e) ->
  suggestion = $('#organization_search').data('suggestion')
  return unless suggestion?

  e.field.parents('form').data('dirty', true)
  e.field.find('.organization_id').val(suggestion.id)
  e.field.find('.organization_name').html(suggestion.name)
  $('#organization_search').val('')
  $('#organization_search').data('suggestion', null)
  $('#add-selected-organization').addClass('disabled')
  $('#add-selected-organization').addClass('btn-info')
