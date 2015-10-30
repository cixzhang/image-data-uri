{CompositeDisposable} = require 'atom'
Library = require './marker-decoration-library'

module.exports = ImageDataUri =
  activate: (state) ->
    @active = true
    @libraries = {}
    @disposables = new CompositeDisposable
    @disposables.add atom.workspace.observeTextEditors (e) => @subscribe e

    atom.commands.add(
      'atom-text-editor', 'image-data-uri:toggle': => @toggle()
    )

  deactivate: ->
    @active = false
    @disposables.dispose()
    @disposables.clear()
    for editorId, library of @libraries
      library.destroy()

  toggle: ->
    if @active
      @deactivate()
    else @activate()

  subscribe: (editor) ->
    @libraries[editor.id] = new Library(editor)
    @disposables.add editor.onDidStopChanging => @parse editor

  parse: (editor) ->
    library = @libraries[editor.id]
    exp = /(data:image\/(?:png|gif|jpg|jpeg|svg);base64,[A-z0-9\/\+\s]*[=]*)/g
    editor.scan(exp, (result) => @mark(library, result))

  mark: (library, scanned) ->
    library.decorate(scanned.range)
