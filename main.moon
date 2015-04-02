love.load =  ->
  export vector = require 'lib.hump.vector'
  export gamestate = require 'lib.hump.gamestate'

  require 'class.physical'
  require 'class.player'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game
