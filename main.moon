love.load =  ->
  export gamestate = require 'lib.hump.gamestate'

  require 'class.player'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game
