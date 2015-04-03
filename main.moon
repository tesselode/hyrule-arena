love.load =  ->
  export * -- globalizes all variables in this scope

  vector = require 'lib.hump.vector'
  gamestate = require 'lib.hump.gamestate'
  bump = require 'lib.bump'
  util = require 'lib.util'
  flux = require 'lib.flux'

  require 'class.physical'
  require 'class.projectile'
  require 'class.player'
  require 'class.enemy'
  require 'class.map'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game

love.update = (dt) ->
  flux.update dt
