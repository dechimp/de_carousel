$ ->
  $carousel = $('.js-carousel')
  carouselDots = $('.slider-dot')
  $carouselRightBtn = $('.js-carousel-right-btn')
  $carouselLeftBtn = $('.js-carousel-left-btn')
  $carouselcontainer = $('.js-carouselcontainer')
  flippers = $('.flippers')
  carousel_slides = $carousel.children()

  carouselEnabled = true
  autoAdvanceEnabled = false
  autoAdvanceInterval = 500
  carouselIndex = 0
  carouselScreenCount = 3
  autoAdvanceDelay = 5000
  textEmergeDelay = 800

  ### Carousel ###

  get_upcoming_slide_text = ->
    upcoming_slide = carousel_slides.get(carouselIndex)
    slide_text = $(upcoming_slide).children().first()
    slide_text

  reset_emerge_for_inactive_slides = ->
    slide_text_elements = $('.slide-text')
    slide_text_elements.splice carouselIndex, 1
    slide_text_elements.children('p').removeClass 'emerge'
    return

  emerge = ->
    setTimeout (->
      slide_text = get_upcoming_slide_text()
      slide_text.children('p').eq(0).addClass 'emerge'
      timeoutDur = textEmergeDelay
      console.log textEmergeDelay
      i = 1
      l = slide_text.children('p').length
      while i < l
        do (i) ->
          _p = slide_text.children('p').eq(i)
          setTimeout (->
            _p.addClass 'emerge'
            return
          ), timeoutDur
          timeoutDur += textEmergeDelay
          return
        i++
      reset_emerge_for_inactive_slides()
      return
    ), 600
    return

  changeDotAppearance = (selectedDotElement) ->
    carouselDots.removeClass 'dot-selected'
    selectedDotElement.addClass 'dot-selected'
    return

  moveCarousel = ->
    translate3d = 'translate3d(-' + carouselIndex * $carousel.width() / 3 + 'px,0,0)'
    $carousel.css
      '-webkit-transform': translate3d
      '-ms-transform': translate3d
      'transform': translate3d
    emerge()
    flippers.removeClass 'hidden'
    changeDotAppearance $('.slider-dot[data-dotindex="' + carouselIndex + '"]')
    return

  slideTo = (index) ->
    carouselIndex = index
    moveCarousel()
    return

  slideForward = ->
    if carouselIndex + 1 >= carouselScreenCount
      carouselIndex = 0
    else
      carouselIndex++
    moveCarousel()
    return

  slideBack = ->
    if carouselIndex <= 0
      carouselIndex = carouselScreenCount - 1
    else
      carouselIndex--
    moveCarousel()
    return

  startAutoAdvance = ->
    if carouselEnabled and autoAdvanceEnabled
      autoAdvanceInterval = setInterval((->
        slideForward()
        return
      ), autoAdvanceDelay)
    else
      autoAdvanceInterval = false
    return

  carouselDots.click (e) ->
    e.preventDefault()
    clickedDot = $(this)
    newIndex = $(this).data('dotindex')
    slideTo newIndex
    clearInterval autoAdvanceInterval
    startAutoAdvance()
    return
  $carouselcontainer.on 'click', '.flipper', ->
    clearInterval autoAdvanceInterval
    startAutoAdvance()
    return
  $carouselcontainer.on 'click', '.rightbutton', ->
    slideForward()
    return
  $carouselcontainer.on 'click', '.leftbutton', ->
    slideBack()
    return
  $(window).resize ->
    moveCarousel()
    return

  emerge()
  flippers.show()
  startAutoAdvance()

  ### flippers ###

  if carouselEnabled
    flippers.on('mouseover', ->
      flippers.removeClass 'hidden'
      return
    ).on 'mouseleave', ->
      flippers.addClass 'hidden'
      return
  else
    flippers.addClass 'hidden'
    carouselDots.hide()
