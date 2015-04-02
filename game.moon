Player = require 'class.player'

game = {}

game.enter =  =>
  @instance = {}
  table.insert @instance, Player 400, 300

game.update = (dt) =>
  for k, v in pairs @instance
    if v.update
      v\update dt

game.draw =  =>
  for k, v in pairs @instance
    if v.draw
      v\draw!

game
