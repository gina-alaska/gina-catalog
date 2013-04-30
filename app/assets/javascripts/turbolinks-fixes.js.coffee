Bootstrap = {
  init: ->
    $('[data-spy="affix"]').each ->
      if offset = $(this).data('offset-top')
        $(this).affix({ offset: offset })
      else
        $(this).affix()
}

$(document).on('page:load', Bootstrap.init)