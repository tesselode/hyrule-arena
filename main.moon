export Gamestate = require 'lib.hump.gamestate'

game = require 'game'

love.load =  ->
  with Gamestate
    .registerEvents!
    .switch game
