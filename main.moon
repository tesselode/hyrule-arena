love.load =  ->
  export vector = require 'lib.hump.vector'
  export gamestate = require 'lib.hump.gamestate'
  export bump = require 'lib.bump'

  require 'class.physical'
  require 'class.player'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game
