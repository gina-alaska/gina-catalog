$(document).on 'click', '[data-behavior="move-top"]', ->
  $('[data-behavior="move-top"]').hide();
  $('[data-behavior="move-left"]').show();


  $('.map-left').slideUp(done: ->
    $('.map-container').appendTo('.map-top')
    $('.map-top').slideDown done: ->
      $('.search-map').data('map').invalidateSize()
  )


  # $('.search-map').data('map').invalidateSize()
  # $('.map-top').slideUp()

$(document).on 'click', '[data-behavior="move-left"]', ->
  $('[data-behavior="move-top"]').show();
  $('[data-behavior="move-left"]').hide();

  $('.map-top').slideUp done: ->
    $('.map-container').appendTo('.map-left')

    $('.search-map').data('map').invalidateSize()
    $('.map-left').slideUp()
    $('.map-left').slideDown 'fast', ->
      $('.search-map').data('map').invalidateSize()
