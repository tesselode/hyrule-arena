love.load =  ->
  export * -- globalizes all variables in this scope

  images = {}
  images.shadow = love.graphics.newImage 'images/shadow.png'
  images.gemBlue = love.graphics.newImage 'images/placeholder/gemBlue.png'

  vector = require 'lib.hump.vector'
  gamestate = require 'lib.hump.gamestate'
  camera = require 'lib.hump.camera'
  bump = require 'lib.bump'
  util = require 'lib.util'
  tick = require 'lib.tick'
  flux = require 'lib.flux'

  require 'class.common'
  require 'class.physical'
  require 'class.wall'
  require 'class.projectile'
  require 'class.gem'
  require 'class.player'
  require 'class.enemies.enemy'
  require 'class.enemies.follower'
  require 'class.enemies.octorok'
  require 'class.enemies.tektite'
  require 'class.map'
  require 'class.room'

  require 'game'

  with gamestate
    .registerEvents!
    .switch Game

love.update = (dt) ->
  --update some libraries
  tick.update dt
  flux.update dt

love.keypressed = (key) ->
  if key == 'escape' -- change this later
    love.event.quit!
