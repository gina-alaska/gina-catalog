# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

sitemanager_toolbar_events_bound = null
sitemanager_toolbar_direction = null
sitemanager_toolbar_btn = null

toggleToolbarHandler = (evt) ->
  evt.preventDefault()
  btn = $(this)
  dir = btn.data('dir')
  target = $(btn.data('target'))
  toggleToolbar(target, btn, dir)

toggleToolbar = (target, btn, dir, animate = true) ->
  distance = $(target).outerWidth() - 38
  
  if $(target).hasClass('hidden')
    sitemanager_toolbar_btn = null
    sitemanager_toolbar_direction = null
    opts = { left: 0 }
  else
    sitemanager_toolbar_btn = btn
    sitemanager_toolbar_direction = dir
    if dir == 'left'
      opts = { left: "-#{distance}px" }
    else
      opts = { left: "#{distance}px" }

  if animate? and animate
    $(target).stop().animate(opts, { queue: false, duration: 300 }).toggleClass('hidden')
  else
    $(target).css(opts).toggleClass('hidden')
  

updateSitemanagerToolbar = ->
  if sitemanager_toolbar_btn? and sitemanager_toolbar_direction?
    btn = $(sitemanager_toolbar_btn)
    dir = btn.data('dir')
    target = $(btn.data('target'))
    
    toggleToolbar(target, btn, dir, false)

bindSitemanagerEventHandlers = ->
  $(document).on 'page:change', updateSitemanagerToolbar
  $(document).on 'click', '[data-action="hide_toolbar"]', toggleToolbarHandler
  
  sitemanager_toolbar_events_bound = true
  
$ ->
  bindSitemanagerEventHandlers() unless sitemanager_toolbar_events_bound
