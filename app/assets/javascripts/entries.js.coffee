$(document).on 'ready page:load', ->
  $('[data-behavior="selectize-tags"]').selectize({
    plugins: ['remove_button'],
    delimiter: ',',
    persist: false,
    hideSelected: true,
    load: (query, callback) ->
      return callback() if query.length == 0
      $.ajax({
        url: '/manager/entries/tags',
        type: 'GET',
        error: -> callback(),
        success: (res) -> callback(res)
      })
    create: (input) ->
      { value: input, text: input }
  })

  $('[data-behavior="selectize-collections"]').selectize({
    plugins: ['remove_button'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    load: (query, callback) ->
      return callback() if query.length == 0
      $.ajax({
        url: '/manager/entries/collections',
        type: 'GET',
        error: -> callback(),
        success: (res) -> callback(res)
      })
    create: false
  })
  
