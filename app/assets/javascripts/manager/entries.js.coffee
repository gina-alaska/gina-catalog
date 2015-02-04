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
        url: "/manager/collections/search",
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
    render: {
      option: (item, escape) ->
        "<div>#{item.name}</div>"
    },
    load: (query, callback) ->
      return callback() if query.length == 0
      $.ajax({
        url: '/manager/collections/search',
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