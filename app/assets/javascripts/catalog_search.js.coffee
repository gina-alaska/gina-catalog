@CatalogSearch = {
  update: (el, value) ->
    $(el).val(value)
  
  submit: (format = 'js', track = true) ->
    form = $('#catalog_search_form')
    url = form.attr('action') + '?'
    if format != 'js'
      url = url + 'format=' + format + '&'
    url = url + form.serialize()
    
    state = { behavior: 'search-results-load' }
    
    if $('#map')
      state.map_size = $('#map_canvas').data('map').map_state.size
    
    if track
      History.pushState(state, null, url)
    else
      CatalogSearch.load(url, false)
    
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

$(document).on("click", '[data-behavior="stash"]', (evt) ->
  evt.preventDefault()
  CatalogSearch.update($(this).data("target"), $(this).data("value"))
  if $(this).data('titleTarget')
    $($(this).data('titleTarget')).html($(this).data('title'))
)

$(document).on("click", "[data-behavior='load_collection']", (evt) ->
  evt.preventDefault()
  
  target = $(this).data("target")
  if parseInt($(target).val()) == parseInt($(this).data("value"))
    CatalogSearch.update(target, '')
    CatalogSearch.submit()
  else
    CatalogSearch.update(target, $(this).data("value"))
    CatalogSearch.submit()
)
