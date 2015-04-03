love.load =  ->
  export * -- globalizes all variables in this scope

  vector = require 'lib.hump.vector'
  gamestate = require 'lib.hump.gamestate'
  bump = require 'lib.bump'
  util = require 'lib.util'

  require 'class.physical'
  require 'class.projectile'
  require 'class.player'
  require 'class.map'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game
