
ImageView = require './image-view'

module.exports =
  class MarkerDecorationLibrary
    constructor: (@editor) ->
      @decors = []

    decorate: (range) ->
      decor = false
      start = JSON.stringify(range.start)
      for d in @decors when decor is false
        startD = JSON.stringify(d.marker.getBufferRange().start)
        decor = if startD is start then d else false
      if !decor
        decor = @create(range)
      else
        decor.overlay.render()
      return decor

    create: (range, id) ->
      marker = @editor.markBufferRange(range)
      overlay = new ImageView(@editor, marker)
      decoration = @editor.decorateMarker(marker, {
        type: 'overlay'
        item: overlay.getElement()
        class: 'image-data-uri'
        position: 'tail'
      })

      decor =
        marker: marker
        overlay: overlay
        decoration: decoration
      decor.disposable = marker.onDidDestroy(() => @destroy(decor))
      @decors.push(decor)
      return decor

    destroy: (decor) ->
      if decor
        decor.disposable.dispose()
        decor.marker.destroy()
        index = @decors.indexOf(decor)
        @decors.splice(index, 1)
      else
        while @decors.length
          @destroy(@decors[0])
