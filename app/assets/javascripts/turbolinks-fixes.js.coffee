bootstrap_events_bound = null

initBootstrap = ->
  $('[data-spy="affix"]').each ->
    if offset = $(this).data('offset-top')
      $(this).affix({ offset: offset })
    else
      $(this).affix()

bindBootstrapEventHandlers = ->
  # initBootstrap()
  $(document).on 'page:load', initBootstrap
  bootstrap_events_bound = true

$ ->
  bindBootstrapEventHandlers() unless bootstrap_events_bound

$(document).on 'page:change', ->
  if window._gaq?
    _gaq.push ['_trackPageview']
  else if window.pageTracker?
    pageTracker._trackPageview()