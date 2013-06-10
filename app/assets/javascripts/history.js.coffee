$(document).on 'click', 'a[data-behavior="search-results-load"]', (evt) ->
  evt.preventDefault()
  href = $(this).attr('href')
  state = { behavior: 'search-results-load' }
  if $('#map')
    state.map_size = $('#map').data('map').map_state.size
  
  History.pushState(state, null, href)

$(document).submit (evt) ->
  if $(evt.target).data('behavior') == "search-results-load"
    url = $(evt.target).attr('action') + '?' + $(evt.target).serialize()
    evt.preventDefault()
    state = { behavior: 'search-results-load' }
    if $('#map')
      state.map_size = $('#map').data('map').map_state.size
  
  History.pushState(state, null, url)
  
statechange = (evt) ->
  state = History.getState()
  
  if state.data
    switch state.data.behavior
      when 'search-results-load'
        if $('#map')
          $('.spinner-container').spin('large')
          $.ajax({ url: state.url, dataType: 'script', global: false })
          $('#map').data('map').loadMapState(state.data.map_size)

$ ->
  History.Adapter.bind(window, 'statechange', statechange)