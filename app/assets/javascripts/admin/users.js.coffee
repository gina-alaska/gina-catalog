# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

UserSuggestion = {
  add: (target, suggestion) ->
    $(target).data('suggestion', suggestion)
    $(target).val(UserSuggestion.display_key(suggestion));
    $('#add-selected-user').removeClass('disabled')
    $('#add-selected-user').removeClass('btn-info')
    $('#add-selected-user').addClass('btn-success')

  display_key: (d) ->
    display = "#{d.name}"
    display
}

$(document).on 'ready turbolinks:load',  ->
  userstypehead = new TypeAheadField('[data-behavior="typeahead"][data-name="users"]', {
    display_key: UserSuggestion.display_key
  })

  userstypehead.on 'typeahead:selected', (e, suggestion, dataset) ->
    target = this
    $(document).trigger('user:suggestion', [target, suggestion])

  userstypehead.on 'keyup', ->
    if $(this).val() == ""
      target = this
      $(target).data('suggestion', "")
      $('#add-selected-user').removeClass('btn-success')
      $('#add-selected-user').addClass('disabled')
      $('#add-selected-user').addClass('btn-info')

$(document).on 'user:suggestion', (e, target, suggestion) ->
  UserSuggestion.add(target, suggestion)

$(document).on 'nested:fieldAdded:permissions', (e) ->
  suggestion = $('#user_search').data('suggestion')
  return unless suggestion?

  e.field.find('.user_id').val(suggestion.id)
  e.field.find('.name').html(suggestion.name)
  e.field.find('.role').prop('checked', true)
  $('#user_search').val('')
  $('#user_search').data('suggestion', null)
  $('#add-selected-user').addClass('disabled')
  $('#add-selected-user').addClass('btn-info')
