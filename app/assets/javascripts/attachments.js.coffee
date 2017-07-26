# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class @ImageChooser
  constructor: (@modal, @url) ->

  show: (e) =>
    target = $(@modal).modal()

    # target = $(e.currentTarget).data('target')
    $(target).find('.loading').show();
    $(target).find('.content').hide();

    # if $(@btn).parent().find('.active').removeClass('active').length > 0
    #   $(@btn).addClass('active')

    images_url = @url
    template = Handlebars.compile($(target).find('template').html())
    $.getJSON(images_url).done (data) =>
      $(target).find('.loading').hide();
      $(target).find('.content').html(' ');
      for image in data
        $(target).find('.modal-body .content').append(template(image))
      $(target).find('.content').show();
