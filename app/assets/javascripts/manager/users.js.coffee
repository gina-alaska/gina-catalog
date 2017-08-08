# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready turbolinks:load',  ->
  usertypeahead = new TypeAheadField('[data-behavior="typeahead"][data-name="user"]', {
    display_key: (d) ->
      "#{d.name} (#{d.email})"
  })
  usertypeahead.on 'typeahead:selected', (e, suggestion, dataset) ->
    window.location = "/manager/permissions/new?user_id=#{suggestion.id}"
