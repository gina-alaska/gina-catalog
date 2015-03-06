# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'submit', 'form[data-behavior="confirm-unsaved-changes"]', ->
    $(this).data("dirty", false)

  $(document).on 'change', 'form[data-behavior="confirm-unsaved-changes"]', ->
    $(this).data("dirty", true)

  $(document).on 'page:before-change', (e) ->
    form = $('form[data-behavior="confirm-unsaved-changes"]')

    if form.length > 0 and form.data("dirty")
      msg = form.data("message") || "There are unsaved changes, you will lose these changes if you leave the page!"
      return confirm(msg)      
  
  $(window).on 'beforeunload', (e) ->
    form = $('form[data-behavior="confirm-unsaved-changes"]')

    if form.length > 0 and form.data("dirty")
      msg = form.data("message") || "There are unsaved changes, you will lose these changes if you leave the page!"
      (e || window.event).returnValue = msg;
      msg
