Spine = require('spine')
$ = Spine.$
{Panel} = require('spine.mobile')
Player = require('models/player')
Game = require('models/game')

class GamesList extends Panel
  events:
    'tap .item': 'click'

  title: 'Games'

  className: 'games list listView'

  constructor: ->
    super

    Game.bind('refresh change', @render)
    @addButton('+ Game', @add).addClass('right')
   
  render: =>
    items = Game.all()
    @html require('views/games/item')(items)

  click: (e) ->
    item = $(e.target).item()
    @navigate('/games', item.id, trans: 'right')

  add: ->
    @navigate('/games/create', trans: 'right')


class PlayersList extends Panel
  events:
    'tap .item': 'click'
    'tap #new': 'new'
    'tap #points li': 'score'

  title: 'Game'

  className: 'players list listView'

  constructor: ->
    super
    Player.bind('refresh change', @render)

    @addButton('Games', @back)
    @active (params) ->
      @change(params.id)

  render: =>
    if @game
      @players = @game.players().all()
      if @players.length is 0
        @game.players().create(name: @game.owner, points: 0)
        @players = @game.players().all()

      @html require('views/players/item')(@players)
      @.append('<a id="new">New Player</a>')
      @.append( require('/views/games/points')(@game))

  change: (id) ->
    @game = Game.find(id)
    @render()

  new: ->
    @navigate('/games/'+@game.id+'/add_player', trans: 'right')

  score: (e) =>
    value = Number($(e.target).text())
    @player.points += value
    @player.save() 

  click: (e) =>
    @player = $(e.target).item()
    @player.activate()

   back: ->
    @navigate('/games', trans: 'left')

class PlayerCreate extends Panel
  elements:
    'input[type="text"]': 'input'
    'input[type="submit"]': 'submitButton'

  events:
    'submit form': 'submit'
    'click input[type="submit"]': 'submit'

  className: 'players createView'

  constructor: ->
    super
    @addButton('Cancel', @back)
    @addButton('Add', @submit).addClass('right')
    @active (params) ->
      @change(params.id)

  render: ->
    @html require('views/players/form')()

  submit: (e) =>
    e.preventDefault()
    Player.create(name: @input.val(), points: 0, game: @game)
    @navigate('/games', @game.id, trans: 'left')

  back: ->
    @navigate('/games', @game.id, trans: 'left')

  change: (id) ->
    @game = Game.find(id)
    @render()

  deactivate: ->
    super
    @input.blur()

class GamesCreate extends Panel
  elements:
    'input[name="owner"]': 'ownerEl'
    'select[name="typer"]': 'typeEl'
    'input[name="point_limit"]': 'pointEl'

  events:
    'submit form': 'submit'
    'click input[type="submit"]': 'submit'

  className: 'games createView'

  constructor: ->
    super
    @addButton('Cancel', @back)
    @addButton('Start', @submit).addClass('right')
    @render()

  render: ->
    @html require('views/games/form')()

  submit: (e) ->
    e.preventDefault()
    game = Game.create(typer: @typeEl.val(), owner: @ownerEl.val(), point_limit: @pointEl.val())
    if game
      #@input.val('')
      @navigate('/games', game.id, trans: 'left')

  back: ->
    @navigate('/games', trans: 'left')

  deactivate: ->
    super
    @ownerEl.blur()

class Games extends Spine.Controller
  constructor: ->
    super

    @list    = new GamesList
    @show    = new PlayersList
    @create  = new GamesCreate
    @add_player = new PlayerCreate
    @routes
      '/games':                   (params) -> @list.active(params)
      '/games/:id':               (params) -> @show.active(params)
      '/games/:id/add_player':    (params) -> @add_player.active(params)
      '/games/create':            (params) -> @create.active(params)

    Game.fetch()
    Player.fetch()
 
module.exports = Games
