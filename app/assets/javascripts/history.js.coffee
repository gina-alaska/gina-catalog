$(document).on 'click', 'a[data-behavior="search-results-load"]', (evt) ->
  evt.preventDefault()
  return false if $(this).data('disabled')
  
  href = $(this).attr('href')
  state = { behavior: 'search-results-load' }
    
  if $('#map_canvas')
    state.map_size = $('#map_canvas').data('map').map_state.size
  
  History.pushState(state, null, href)


# $(document).submit (evt) ->
#   if $(evt.target).data('behavior') == "search-results-load"
#     evt.preventDefault()
#     url = $(evt.target).attr('action') + '?' + $(evt.target).serialize()
#     state = { behavior: 'search-results-load' }
#     if $('#map')
#       state.map_size = $('#map').data('map').map_state.size
#   
#   History.pushState(state, null, url)
  
statechange = (evt) ->
  state = History.getState()
  loadState(state)
            
loadState = (state) ->
  if state.data
    switch state.data.behavior
      when 'search-results-load'
        if $('#map_canvas')
          $('.spinner-container').spin('large')
          CatalogSearch.load(state.url)
          $('#map_canvas').data('map').loadMapState(state.data.map_size)  

$ ->
  History.Adapter.bind(window, 'statechange', statechange)