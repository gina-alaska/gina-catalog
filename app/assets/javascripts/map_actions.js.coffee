$(document).on 'click', '[data-behavior="move-top"]', ->
  $('[data-behavior="move-top"]').hide();
  $('[data-behavior="move-left"]').show();

  $('.map-left').hide()

  $('.map-container').appendTo('.map-top')

  $('.search-map').data('map').invalidateSize()
  $('.map-top').hide()
  $('.map-top').show ->
    $('.search-map').data('map').invalidateSize()

$(document).on 'click', '[data-behavior="move-left"]', ->
  $('[data-behavior="move-top"]').show();
  $('[data-behavior="move-left"]').hide();

  $('.map-top').hide ->
    $('.map-container').appendTo('.map-left')

    $('.search-map').data('map').invalidateSize()
    $('.map-left').hide()
    $('.map-left').show 'fast', ->
      $('.search-map').data('map').invalidateSize()
