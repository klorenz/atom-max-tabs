{View} = require 'atom'

module.exports =
class MaxTabsView extends View
  @content: ->
    @div class: 'max-tabs overlay from-top', =>
      @div "The MaxTabs package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "max-tabs:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "MaxTabsView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
