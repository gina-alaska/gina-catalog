# AceEditor class
#   Currently this will find the selected dom elements and turn any textareas found inside into ace editor instances.  Each selector dom element should only contain one textarea, for multiple editors on a page create multiple dom elements with the selector
#   All textareas that are transformed into editors are hidden but left in the dom so form submissions work correctly.
#
#   Any items that have a data-action attribute will also be used to control the sibling editor
#
# USAGE:
# <div class="ace">
# <textarea name="fieldname"></textarea>
# </div>
# <script>
#   editors = new AceEditor('.ace');
# </script> 

class @AceEditor
  constructor: (selector)->
    @editors = {}
    @actions = {}
    @setupHandlers()
    @initEditor(item) for item in $(selector)
    
  htmlEncode: (str) ->
    str.replace /[&<>"']/g, ($0) ->
      "&" + {"&":"amp", "<":"lt", ">":"gt", '"':"quot", "'":"#39"}[$0] + ";"  
    
  setupHandlers: () ->
    @addHandler 'insert', (editor, btn) =>
      if tag = btn.data('tag')
        start_tag = "<#{tag}>"
        end_tag = "</#{tag}>"
      else if html = btn.data('html')
        start_tag = html
        end_tag = ''
         
      @wrapSelectionWithTags(editor, start_tag, end_tag)
      
    @addHandler 'undo', (editor, btn) =>
      editor.getSession().getUndoManager().undo()
      
    @addHandler 'redo', (editor, btn) =>
      editor.getSession().getUndoManager().redo()
      
  initEditor: (el) ->
    textarea = $(el).find('textarea')    
    id = $(textarea ).attr('id')
    editor_el = $("""<div class='editor'>#{@htmlEncode(textarea.val())}</div>""")
    editor_el.insertAfter(textarea)
    
    textarea.hide()
    editor = ace.edit(editor_el.get(0))
    editor.setTheme("ace/theme/textmate")
    editor.getSession().setMode("ace/mode/html")
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    editor.getSession().setUseWrapMode(true)
    
    editor.on 'change', (e) =>
      $(textarea).val(editor.getValue())
      
    @editors[id] = editor
    
    $(el).find('[data-action]').on 'click', (evt) => 
      evt.preventDefault()  
      btn = $(evt.currentTarget)
      if @actions[btn.data('action')]
        @actions[btn.data('action')](editor, btn, this)
      
  addHandler: (name, func) ->
    @actions[name] = func
    
  wrapSelectionWithTags: (editor, start_tag = '', end_tag = '') ->
    session = editor.getSession()    
    range = editor.selection.getRange()
    
    if range.isEnd(range.start.row, range.start.column)
      editor.insert(start_tag)
      pos = editor.getCursorPosition()
      editor.insert(end_tag)
      editor.moveCursorToPosition(pos)
    else        
      pos = session.insert(range.end, end_tag)
      session.insert(range.start, start_tag)
      editor.selection.clearSelection()
      
    editor.focus()