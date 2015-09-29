# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  ace.config.set('workerPath', '/assets/ace-builds/src-noconflict/')

  if $('[data-editor="ace"]').size() > 0
    el = $('[data-editor="ace"]')
    target = $(el.data('target'))
    editor = ace.edit(el.attr('id'))
    mode = el.data('mode') || 'html_ruby'

    editor.setTheme('ace/theme/github')
    editor.getSession().setMode("ace/mode/#{mode}")
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    editor.getSession().setUseWrapMode(true)

    el.addClass('loading')
    editor.setValue(target.val())

    editor.getSession().on 'change', (e) ->
      console.log target
      target.val(editor.getValue())
