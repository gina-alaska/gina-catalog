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

$(document).on 'ready page:load', ->
  for item in $('[data-behavior="float-checked"] input:checked')
    $(item).parents('.facet-item').prependTo($(item).parents('.facet-list'))

  $('.sort-by').click (event) ->
    target = $($(this).data('target'))
    type = $(this).data('sort')
    direction = $(this).data('direction')
    $(this).data('direction', if direction == 'asc' then 'desc' else 'asc')
    facets = target.children().toArray()

    facets.sort (a, b) ->
      an = $(a).data(type)
      bn = $(b).data(type)
      if an > bn
        return if direction == 'asc' then 1 else -1
      if an < bn
        return if direction == 'asc' then -1 else 1
      0
    $(facets).detach().appendTo target
    iconSwap($(this), direction)
    event.preventDefault()
    return

  iconSwap = (target, direction) ->
    sort = $(target).data('sort')
    icon = $(target).find('i')

    if sort == 'name'
      if direction == 'asc'
        $(icon).removeClass('fa-sort-alpha-desc').addClass('fa-sort-alpha-asc')
      else
        $(icon).removeClass('fa-sort-alpha-asc').addClass('fa-sort-alpha-desc')
    else
      if direction == 'asc'
        $(icon).removeClass('fa-sort-numeric-desc').addClass('fa-sort-numeric-asc')
      else
        $(icon).removeClass('fa-sort-numeric-asc').addClass('fa-sort-numeric-desc')
    return

  $('.sort-by').click (event) ->
    current = $(this)
    targets = $(this).parent().children().each (button, current) ->
      if button == current
        $(button).addClass('active')
      else
        $(button).removeClass('active')
