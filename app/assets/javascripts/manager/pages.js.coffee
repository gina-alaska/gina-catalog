$('document').ready ->
  $("#add_new_page").submit (e) ->
    e.preventDefault()
  
    url = $(this).attr('action')  
    pageName = $("#new_page_name").val()
    
    $.ajax
      type: 'post'
      data: {new_page_name: pageName }
      url: url
      dataType: 'html'
      success: (html) ->
        $("#new_page_name").val("")
        #Get all the tab-panes
        tab_panes = $(html).find("#page_content .tab-pane")
        
        #Only add in the tab panes that don't already exist on the page.
        # This preserves any edited content. 
        for tab_pane in tab_panes 
          do (tab_pane) ->
            unless $("##{$(tab_pane).attr('id')}").length > 0
              $("#page_content div.tab-pane:last").after(tab_pane)
              MarkItUp.markItUp("#page_content > div.tab-pane:last > textarea.editor");
         
        #Replace existing tabs with the returned values, 
        # giving focus to the newly created page
        tabs = $(html).find("#page_tabs ul")
        $("#page_tabs").html(tabs)
        $("#page_tabs .nav-tabs li:last").prev('li').find('a').tab('show')

      error: (html) ->
        
      complete:
        $("#new_page_modal").modal('toggle')