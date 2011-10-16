require('lib/setup')

$        = jQuery
Spine   = require('spine')
{Stage}  = require('spine.mobile')
Games = require('controllers/games')

class App extends Stage.Global
  constructor: ->
    super
    @games = new Games

    Spine.Route.setup(shim:true)
    @navigate '/games'

    $('body').bind 'click', (e) ->
      e.preventDefault()

    $('body').bind 'shake', ->
      if (confirm('Reload?'))
        window.location.reload()


module.exports = App
