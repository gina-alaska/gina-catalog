$(document).on 'click', '[data-toggle="expand"]', (e) ->
  e.preventDefault()
  target = $(e.target).attr('href')
  $(target).toggleClass('in') if $(target).length > 0

  text = $(e.target).text()
  $(e.target).text $(e.target).data('toggletext')
  $(e.target).data('toggletext', text)

$(document).on 'click', '[data-behavior="highlight"]', (e) ->
  e.preventDefault()
  target = $(e.target).attr('href')

  group = $(e.target).data('group')
  if group?
    $("#{group} .active").removeClass('active')

  $(target).toggleClass('active')
