# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ace.config.set('workerPath', '/assets/ace-builds/src-noconflict/')

class AceToolbar
  constructor: (@editor, @mode) ->
    @getBtnHandlers()

  getBtnHandlers: =>
    switch @mode
      when 'html_ruby'
        html = new AceHTMLToolbar()
        @handlers = html.handlers
      else
        html = new AceHTMLToolbar()
        @handlers = html.handlers

  call: (action, btn) =>
    if @handlers[action]?
      @handlers[action](btn, this)
      @focus()

  addHandler: (name, func) ->
    @handlers[name] = func

  undo: () ->
    @editor.getSession().getUndoManager().undo()

  redo: () ->
    @editor.getSession().getUndoManager().redo()

  wrapSelectionWithTags: (start_tag = '', end_tag = '') ->
    session = @editor.getSession()
    range = @editor.selection.getRange()

    if range.isEnd(range.start.row, range.start.column)
      @editor.insert(start_tag)
      pos = @editor.getCursorPosition()
      @editor.insert(end_tag)
      @editor.moveCursorToPosition(pos)
    else
      pos = session.insert(range.end, end_tag)
      session.insert(range.start, start_tag)
      @editor.selection.clearSelection()

  focus: () =>
    @editor.focus()
    setTimeout(=>
      @editor.focus()
    , 500)

class AceHTMLToolbar
  handlers: {
    insert: (btn, scope) ->
      if tag = btn.data('tag')
        start_tag = "<#{tag}>"
        end_tag = "</#{tag}>"
      else if html = btn.data('html')
        start_tag = html
        end_tag = ''
      else if start = btn.data('start')
        start_tag = start
        end_tag = btn.data('end') || ""

      scope.wrapSelectionWithTags(start_tag, end_tag)

    chooser: (btn, scope) ->
      target = $(btn).data('target')
      $(target).find('.loading').show();
      $(target).find('.content').hide();

      if $(btn).parent().find('.active').removeClass('active').length > 0
        $(btn).addClass('active')

      images_url = $(btn).attr('href') || $(btn).data('url')
      template = Handlebars.compile($(target).find('template').html())
      $.getJSON(images_url).done (data) =>
        $(target).find('.loading').hide();
        $(target).find('.content').html(' ');
        for image in data
          $(target).find('.modal-body .content').append(template(image))
        $(target).find('.content').show();

    link: (btn, scope) ->
      $(btn).parents('.modal').modal('hide')
      url = $(btn).data('url')
      title = $(btn).data('title')
      scope.wrapSelectionWithTags("<a title='#{title}' href='#{url}' />", '</a>')


    image: (btn, scope) ->
      $(btn).parents('.modal').modal('hide')
      scope.wrapSelectionWithTags("<img src='#{$(btn).data('url')}' />\n", '')

    undo: (btn, scope) ->
      scope.undo()

    redo: (btn, scope) ->
      scope.redo()
  }

$(document).on 'ready turbolinks:load', ->
  if $('[data-editor="ace"]').length > 0
    $('[data-submenu]').submenupicker();

    el = $('[data-editor="ace"]')
    textarea = $(el).find('.editor')
    target = $(el.data('target'))
    editor = ace.edit(textarea.attr('id'))
    mode = el.data('mode') || 'html_ruby'
    toolbar = new AceToolbar(editor, mode)

    $(document).on 'click', '[data-action]', (evt) =>
      evt.preventDefault()
      btn = $(evt.currentTarget)
      toolbar.call(btn.data('action'), btn)

    editor.setTheme('ace/theme/github')
    editor.getSession().setMode("ace/mode/#{mode}")
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    editor.getSession().setUseWrapMode(true)
    editor.$blockScrolling = Infinity

    el.addClass('loading')
    editor.setValue(target.val(), -1)

    editor.getSession().on 'change', (e) ->
      target.val(editor.getValue())
