
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# ----------------------------------------------------------------------------
# markItUp!
# ----------------------------------------------------------------------------
# Copyright (C) 2011 Jay Salvat
# http://markitup.jaysalvat.com/
# ----------------------------------------------------------------------------
# Html tags
# http://en.wikipedia.org/wiki/html
# ----------------------------------------------------------------------------
# Basic set. Feel free to add more tags
# ----------------------------------------------------------------------------

@MarkItUp = 
	defaults:
		onShiftEnter:	{keepDefault:false, replaceWith:'<br />\n'},
		onCtrlEnter:	{keepDefault:false, openWith:'\n<p>', closeWith:'</p>\n'},
		onTab:			{keepDefault:false, openWith:'  '},
		markupSet: [
			{name:'Heading 1', key:'1', openWith:'<h1(!( class="[![Class]!]")!)>', closeWith:'</h1>', placeHolder:'Your title here...' },
			{name:'Heading 2', key:'2', openWith:'<h2(!( class="[![Class]!]")!)>', closeWith:'</h2>', placeHolder:'Your title here...' },
			{name:'Heading 3', key:'3', openWith:'<h3(!( class="[![Class]!]")!)>', closeWith:'</h3>', placeHolder:'Your title here...' },
			{name:'Heading 4', key:'4', openWith:'<h4(!( class="[![Class]!]")!)>', closeWith:'</h4>', placeHolder:'Your title here...' },
			{name:'Heading 5', key:'5', openWith:'<h5(!( class="[![Class]!]")!)>', closeWith:'</h5>', placeHolder:'Your title here...' },
			{name:'Heading 6', key:'6', openWith:'<h6(!( class="[![Class]!]")!)>', closeWith:'</h6>', placeHolder:'Your title here...' },
			{name:'Paragraph', openWith:'<p(!( class="[![Class]!]")!)>', closeWith:'</p>' },
			{separator:'---------------' },
			{name:'Bold', key:'B', openWith:'(!(<strong>|!|<b>)!)', closeWith:'(!(</strong>|!|</b>)!)' },
			{name:'Italic', key:'I', openWith:'(!(<em>|!|<i>)!)', closeWith:'(!(</em>|!|</i>)!)' },
			{name:'Stroke through', key:'S', openWith:'<del>', closeWith:'</del>' },
			{separator:'---------------' },
			{name:'Ul', openWith:'<ul>\n', closeWith:'</ul>\n' },
			{name:'Ol', openWith:'<ol>\n', closeWith:'</ol>\n' },
			{name:'Li', openWith:'<li>', closeWith:'</li>' },
			{separator:'---------------' },
			{
         name:'Picture'
         key:'P'
         className:'pictures' 
         beforeInsert: () => 
           $('#insert_image_chooser_modal').modal()
      },
			{name:'Link', key:'L', openWith:'<a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)>', closeWith:'</a>', placeHolder:'Your text to link...' },
			{separator:'---------------' },
			{
			  name:'Clean', 
			  className:'clean', 
			  replaceWith: (markitup) -> 
			    return markitup.selection.replace(/<(.*?)>/g, "") 
			}
		]
	markItUp: (div, settings = null) ->
		$.extend(true, @defaults, settings) if settings

		$(div).markItUp(@defaults)		

$(document).ready ->
  # $('textarea[data-markitup="html"]').markItUp(MarkItUp.)
  MarkItUp.markItUp("textarea.editor")
  MarkItUp.markItUp('textarea[data-markitup="html"]');
	# $('textarea.editor').markItUp(markitup_settings);