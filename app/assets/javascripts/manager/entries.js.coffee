# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $("#select-two").select2
    multiple: true
    tokenSeparators: [","," "]
    placeholder: "search for a tag"
    minimumInputLength: 1
    initSelection: (element, callback) ->
      data = []
      $(element.val().split(",")).each ->
        data.push(id: this.trim(), name: this.trim())
      callback(data)

    createSearchChoice: (term, data) ->
      if $(data).filter(->
        this.name.localeCompare(term) is 0
      ).length is 0
        id: term,
        name: term

    ajax:
      url: -> $(this).data('url')
      quietMillis: 250
      dataType: 'json'
      data: (term) -> q: term
      results: (data) -> results: data

    formatResult: (item, page) -> item.name
    formatSelection: (item, page) -> item.name
