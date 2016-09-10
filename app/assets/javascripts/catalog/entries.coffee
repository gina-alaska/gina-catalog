# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
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

  $('[data-behavior="selectize-collections"]').selectize({
    plugins: ['remove_button'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    sortField: 'name',
    preload: true,
    render: {
      option: (item, escape) ->
        "<div>#{item.name}</div>"
    },
    load: (query, callback) ->
      $.ajax({
        url: '/api/collections',
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
    create: false
  })

  $('[data-behavior="selectize-regions"]').selectize({
    plugins: ['remove_button'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    preload: true,
    render: {
      option: (item, escape) ->
        "<div>#{item.name}</div>"
    },
    load: (query, callback) ->
      $.ajax({
        url: '/api/regions',
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
    create: false
  })

  $('[data-behavior="selectize-iso_topics"]').selectize({
    plugins: ['remove_button'],
    valueField: 'id',
    labelField: 'long_name_with_code',
    searchField: 'long_name_with_code',
    sortField: [
      {
        field: 'long_name_with_code',
        direction: 'asc'
      },
      {
        field: '$score'
      }
    ],
    preload: true,
    render: {
      option: (item, escape) ->
        "<div>#{item.long_name_with_code}</div>"
    },
    load: (query, callback) ->
      $.ajax({
        url: '/api/iso_topics',
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
    create: false
  })

  $('[data-behavior="selectize-use_agreements"]').selectize({
    valueField: 'id',
    labelField: 'title',
    searchField: 'title',
    sortField: 'title',
    preload: true,
    allowEmptyOption: true,
    render: {
      option: (item, escape) ->
        "<div>#{item.title}</div>"
    },
    load: (query, callback) ->
      $.ajax({
        url: '/api/use_agreements',
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
    create: false
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
