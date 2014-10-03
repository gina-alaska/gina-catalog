if !@GLYNX?
  @GLYNX={ IE: false }

@CatalogSearch = {
  update: (el, value) ->
    $(el).val(value)
    $(el).trigger("change")
  
  submit: (format = 'js', track = true) ->
    form = $('#catalog_search_form')
    url = form.attr('action') + '?'
    if format != 'js'
      url = url + 'format=' + format + '&'
    url = url + form.serialize()
    
    state = { behavior: 'search-results-load' }
    
    if $('#map')
      state.map_size = $('#map_canvas').data('map').map_state.size
    
    if track and !GLYNX.IE
      History.pushState(state, null, url)
    else
      CatalogSearch.load(url, false)
    
  export: (format = 'html') ->
    form = $('#catalog_search_form')
    url = form.attr('action')
    url = url + "/export.#{format}?#{form.serialize()}"
    
    window.open(url)

  load: (url, ajax = true) ->
    if ajax
      $.ajax({ url: url, dataType: 'script', global: false }).complete(CatalogSearch.afterLoad)
    else
      top.location = url
      
  afterLoad: ->
}

$(document).submit (evt) ->
  if $(evt.target).data('behavior') == "search-results-load"
    evt.preventDefault()
    CatalogSearch.submit()


$(document).on("click", '[data-behavior="submit-form"]', (evt) ->
  evt.preventDefault()
  CatalogSearch.submit($(this).data('format'), $(this).data('track'))
)

$(document).on("click", '[data-behavior="export"]', (evt) ->
  evt.preventDefault()
  CatalogSearch.export($(this).data('format'))
)

$(document).on("click", '[data-behavior="stash"]', (evt) ->
  evt.preventDefault()
  CatalogSearch.update($(this).data("target"), $(this).data("value"))
  if $(this).data('titleTarget')
    $($(this).data('titleTarget')).html($(this).data('title'))
)

$(document).on("click", "[data-behavior='load_collection']", (evt) ->
  evt.preventDefault()
  
  target = $(this).data("target")
  clicked_id = $(this).data('value')

  if $(target).val() == ''
    collection_ids = []
  else
    collection_ids = (parseInt(id) for id in ($(target).val().split(",")))
  
  if clicked_id in collection_ids
    collection_ids = (id for id in collection_ids when id isnt clicked_id)
  else
    collection_ids.push(clicked_id)

  $(target).val(collection_ids.join(','))
  CatalogSearch.submit()

  #for each (var collection in coll_array) {
  #  if parseInt($(collection).val()) == parseInt($(this).data("value"))
  #    CatalogSearch.update(collection, '')
  #    CatalogSearch.submit()
  #  else
  #    CatalogSearch.update(collection, $(this).data("value"))
  #    CatalogSearch.submit()
  #  }
)
