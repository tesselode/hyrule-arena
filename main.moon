export gamestate = require 'lib.hump.gamestate'

require 'class.player'

require 'game'

love.load =  ->
  with gamestate
    .registerEvents!
    .switch Game
