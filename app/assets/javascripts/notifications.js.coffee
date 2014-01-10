# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).on 'notification:dismiss', (e, el, count) ->
  item = $('#notification-menu').find(el);
  badge = $('#notification-menu').find('.badge')
  
  badge.html(count)
  badge.removeClass('badge-success').addClass('badge-muted') if count == 0
  
  divider = item.next('.divider')
  divider.remove()
  item.remove()
  
  $('.spinner-container').spin(false)