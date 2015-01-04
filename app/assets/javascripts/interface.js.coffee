class Interface
  constructor: () ->
    @setHeroHeight()

  setHeroHeight: () ->
    $('.home-hero').css('height', window.innerHeight)
    $(window).resize () ->
      $('.home-hero').css('height', window.innerHeight)

new Interface()
