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

sortBtnSwap = (el) ->
  sort = $(el).data('sort')
  dir = $(el).data('direction')
  newdir = if dir == 'asc' then 'desc' else 'asc'
  icon = $(el).find('i.fa')

  $(el).data('direction', newdir)
  $(icon).removeClass("fa-sort-#{sort}-#{dir}").addClass("fa-sort-#{sort}-#{newdir}")

$(document).on 'ready page:load', ->
  for item in $('[data-behavior="float-checked"] input:checked')
    $(item).parents('.facet-item').prependTo($(item).parents('.facet-list'))

  $('.sort-by').click (event) ->
    target = $($(this).data('target'))
    if $(this).hasClass('active')
      sortBtnSwap(this)

    $(this).parents('.sort-btns').find('.sort-by').removeClass('active')
    $(this).addClass('active')

    type = $(this).data('sort')
    direction = $(this).data('direction')
    facets = target.children()

    facets.sort (a, b) ->
      an = $(a).data(type)
      bn = $(b).data(type)
      if an > bn
        return if direction == 'asc' then 1 else -1
      if an < bn
        return if direction == 'asc' then -1 else 1
      0
    $(facets).detach().appendTo target
    event.preventDefault()
