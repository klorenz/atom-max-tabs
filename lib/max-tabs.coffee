MaxTabsView = require './max-tabs-view'

module.exports =
  maxTabsView: null
  lastAccessed: {}
  configDefaults:
    maxTabs: 8

  activate: (state) ->
    #@maxTabsView = new MaxTabsView(state.maxTabsViewState)
    atom.workspaceView.eachPaneView (_paneView) =>
      paneView = _paneView
      for item in paneView.getItems()
        if not (item.id in @lastAccessed)
          @lastAccessed[item.id] = (new Date()).getTime()

      paneView.on "pane:active-item-changed", (event, item) =>
        @lastAccessed[item.id] = (new Date()).getTime()
        @closeTabs(paneView)

  closeTabs: (paneView) ->
    numPanes = atom.workspaceView.getPanes().length
    maxTabs = atom.config.get("max-tabs.maxTabs") / numPanes
    items = paneView.getItems()
    if items.length > maxTabs
      dates = []
      for item in items
        if item.id in @lastAccessed
          dates.push [item, @lastAccessed[item.id]]
        else
          dates.push [item, (new Date()).getTime()]
      dates.sort (a,b) -> a[1] > b[1]

      for d in dates
        break if paneView.getItems().length <= maxTabs
        continue if d[0].isModified()
        paneView.destroyItem(d[0])

      #console.log paneView.getModel().getPanes()

  deactivate: ->
    #@maxTabsView.destroy()

  serialize: ->
    #maxTabsViewState: @maxTabsView.serialize()
