{CompositeDisposable} = require 'atom'
ImageView = require './image-view'

module.exports = ImageDataUri =
  activate: (state) ->
    @active = true
    @marks = {}
    @disposables = new CompositeDisposable
    @disposables.add atom.workspace.observeTextEditors (e) => @subscribe e

    @disposables.add atom.commands.add(
      'atom-workspace', 'image-data-uri:toggle': => @toggle()
    )

  deactivate: ->
    @active = false
    @disposables.dispose()
    @disposables.destroy()

  toggle: ->
    if @active
      @deactivate()
    else @activate()

  subscribe: (editor) ->
    @disposables.add editor.onDidStopChanging => @parse editor

  parse: (editor) ->
    exp = /(data:image\/(?:png|gif|jpg|jpeg|svg);base64,[A-z0-9\/\+\s]*[=]*)/g
    editor.scan(exp, (result) => @mark editor, result)

  mark: (editor, scanned) ->
    range = scanned.range
    marker = editor.markBufferPosition(range.start, {
      persistent: false
      invalidate: 'touch'
    })
    overlay = new ImageView(scanned.matchText);
    decoration = editor.decorateMarker(marker, {
      type: 'overlay'
      item: overlay.getElement()
      class: 'image-data-uri'
    })
