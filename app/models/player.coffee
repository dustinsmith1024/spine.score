Spine = require('spine')

class Player extends Spine.Model
  @configure 'Player', 'active', 'name', 'pic', 'email', 'points'

  @belongsTo 'game', 'models/game'

  @extend Spine.Model.Local

  @default: -> new @(name: 'Namer...')

  activate: ->
    @active = true

  deactivate: ->
    @active = false

module.exports = Player
