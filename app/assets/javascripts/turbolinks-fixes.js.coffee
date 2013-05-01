bootstrap_events_bound = null

initBootstrap = ->
  $('[data-spy="affix"]').each ->
    if offset = $(this).data('offset-top')
      $(this).affix({ offset: offset })
    else
      $(this).affix()

bindBootstrapEventHandlers = ->
  $(document).on 'page:load', initBootstrap
  bootstrap_events_bound = true

$ ->
  bindBootstrapEventHandlers() unless bootstrap_events_bound