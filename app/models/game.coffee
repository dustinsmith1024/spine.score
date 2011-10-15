Spine = require('spine')

class Game extends Spine.Model
  @configure 'Game', 'typer'

  @hasMany 'players', 'models/player'

  @extend Spine.Model.Local

  points: [10,5,1,-1,-5,-10]

  @default: -> new @(typer: 'General')

 
module.exports = Game
