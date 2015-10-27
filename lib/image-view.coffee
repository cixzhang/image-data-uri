
module.exports =
  class ImageView
    constructor: (@editor, @marker) ->
      @el = document.createElement('div')
      @img = document.createElement('img')
      @el.appendChild(@img)
      @render()
      return this

    render: () ->
      bufferRange = @marker.getBufferRange()
      @img.src = @editor.getTextInBufferRange(bufferRange)
      return this

    getElement: () -> @el
