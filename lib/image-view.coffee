
module.exports =
  class ImageView
    constructor: (@image) ->
      @el = document.createElement('div')
      @img = document.createElement('img')
      @img.src = @image

      @el.appendChild(@img);
      return this

    getElement: () -> @el
