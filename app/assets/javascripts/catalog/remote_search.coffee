class @RemoteSearch
  constructor: () ->
    @initEvents()

  initEvents: () =>
    for el in $('[data-behavior="selectize"]')
      label = $(el).data('label') || 'name'
      search_field = $(el).data('search') || label
      sort_field = $(el).data('sort') || search_field
      url = $(el).data('url')
      preload = if $(el).data('preload')? then $(el).data('preload') else true

      $(el).selectize({
        plugins: ['remove_button'],
        valueField: 'id',
        labelField: label,
        searchField: search_field
        sortField: [
          {
            field: sort_field,
            direction: 'asc'
          },
          {
            field: '$score'
          }
        ],
        preload: preload,
        render: {
          option: (item, escape) ->
            "<div>#{item[label]}</div>"
        },
        load: (query, callback) =>
          $.ajax({
            url: url,
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
