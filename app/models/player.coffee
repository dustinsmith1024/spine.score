Spine = require('spine')

class Player extends Spine.Model
  @configure 'Player', 'active', 'name', 'pic', 'email', 'points'

  @belongsTo 'game', 'models/game'

  @extend Spine.Model.Local

  @default: -> new @(name: 'Namer...', points: 0)

  activate: ->
    p.deactivate() for p in @.game().players().all()
    @active = true
    @.save()
    @

  deactivate: ->
    @active = false
    @.save()
    @

module.exports = Player
