# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ContactSuggestion = {
  add: (target, suggestion) ->
    $(target).data('suggestion', suggestion)
    $(target).val(ContactSuggestion.display_key(suggestion));
    $('#add-selected-contact').removeClass('disabled')
    $('#add-selected-contact').removeClass('btn-info')
    $('#add-selected-contact').addClass('btn-success')

  display_key: (d) ->
    display = "#{d.name}"

    if d.email 
      display += " (#{d.email})"
    else
      display += " (No email set)"
        
    display
}

$(document).on 'ready turbolinks:load',  ->
  contactstypehead = new TypeAheadField('[data-behavior="typeahead"][data-name="contacts"]', {
    display_key: ContactSuggestion.display_key
  })

  contactstypehead.on 'typeahead:selected', (e, suggestion, dataset) ->
    target = this
    $(document).trigger('contact:suggestion', [target, suggestion])

  contactstypehead.on 'keyup', -> 
    if $(this).val() == ""
      target = this
      $(target).data('suggestion', "")
      $('#add-selected-contact').removeClass('btn-success')
      $('#add-selected-contact').addClass('disabled')
      $('#add-selected-contact').addClass('btn-info')

$(document).on 'contact:suggestion', (e, target, suggestion) ->
  ContactSuggestion.add(target, suggestion)

$(document).on 'nested:fieldAdded:entry_contacts', (e) ->
  suggestion = $('#contact_search').data('suggestion')
  return unless suggestion?
  
  e.field.parents('form').data('dirty', true)  
  e.field.find('.contact_id').val(suggestion.id)
  e.field.find('.contact_name').html(suggestion.name)
  $('#contact_search').val('')
  $('#contact_search').data('suggestion', null)
  $('#add-selected-contact').addClass('disabled')
  $('#add-selected-contact').addClass('btn-info')