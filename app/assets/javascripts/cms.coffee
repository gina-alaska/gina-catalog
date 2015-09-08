# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
icon_renderer = (name, opts = '') ->
  "<i class=\"fa fa-#{name} #{opts}\"></i>"

button_renderer = (button, id) ->
  $(button).parent().addClass('btn-group')
  button.className = 'btn btn-default btn-sm'
  switch id
    when "bold", "italic", "code", "link", "image"
      button.innerHTML = icon_renderer(id)
    when "heading"
      button.innerHTML = icon_renderer('header')
    when "ol", "ul"
      button.innerHTML = icon_renderer("list-#{id}")
    when "quote"
      button.innerHTML = icon_renderer("quote-right")
    when "html"
      button.innerHTML = icon_renderer('html5')
    when "markdown"
      button.innerHTML = "M#{icon_renderer('arrow-down')}"
    when 'wysiwyg'
      button.innerHTML = icon_renderer('eye')
    else
      button.innerHTML = id

$(document).on 'ready page:load', ->
  ace.config.set('workerPath', '/assets/ace-builds/src-noconflict/')
  for el in $('[data-behavior="woofmark-editor"]')
    editor = woofmark(el, {
      parseMarkdown: megamark,
      parseHTML: domador,
      wysiwyg: false,
      defaultMode: 'markdown',
      render: {
        modes: button_renderer,
        commands: button_renderer
      }
    })
    editor.editable = false

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
