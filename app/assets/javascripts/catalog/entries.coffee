# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  @remotesearch = new RemoteSearch()
  
  $('[data-behavior="selectize-tags"]').selectize({
    plugins: ['remove_button'],
    delimiter: ',',
    create: true,
    persist: false,
    valueField: 'name',
    labelField: 'name',
    searchField: 'name',
    hideSelected: true,
    render: {
      option: (item, escape) ->
        "<div>#{item.name}</div>"
    },
    load: (query, callback) ->
      return callback() if query.length == 0
      $.ajax({
        url: "/api/tags",
        dataType: 'json',
        data: {
          q: encodeURIComponent(query)
        },
        type: 'GET',
        error: ->
          callback()
        success: (res) ->
          callback(res)
      })
  })

$(document).on 'click', '[data-behavior="clear-field"]', (e) ->
  e.preventDefault();

  el = $(this).data('target')

  if $(el).val() != ''
    $(el).val('');

    if $(this).data('autosubmit')
      $(el).parents('form').submit();

$(document).on 'entry-refresh', ->
  for item in $('[data-behavior="entry-refresh"]')
    target = $(item).data('target')
    $.get( document.location ).done (data) ->
      layers = $(data).find(target)
      $(target).replaceWith(layers)
