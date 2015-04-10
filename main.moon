love.load =  ->
  export * -- globalizes all variables in this scope

  images = {}
  animations = {}

  --libraries
  vector = require 'lib.hump.vector'
  gamestate = require 'lib.hump.gamestate'
  camera = require 'lib.hump.camera'
  bump = require 'lib.bump'
  tick = require 'lib.tick'
  flux = require 'lib.flux'
  anim8 = require 'lib.anim8'
  util = require 'lib.util'

  --link animations
  images.linkSpriteSheet = love.graphics.newImage 'images/female link oga 32px.png'
  g = anim8.newGrid 32, 32, images.linkSpriteSheet\getWidth!, images.linkSpriteSheet\getHeight!
  animations.linkRunUp = anim8.newAnimation g('1-4', 1), 0.1
  animations.linkRunRight = anim8.newAnimation g('1-4', 2), 0.1
  animations.linkRunLeft = anim8.newAnimation(g('1-4', 2), 0.1)\flipH!
  animations.linkRunDown = anim8.newAnimation g('1-4', 3), 0.1

  --other images
  images.shadow = love.graphics.newImage 'images/shadow.png'
  images.gemBlue = love.graphics.newImage 'images/placeholder/gemBlue.png'
  images.heartEmpty = love.graphics.newImage 'images/placeholder/heartEmpty.png'
  images.heartFull = love.graphics.newImage 'images/placeholder/heartFull.png'

  --classes
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
  require 'class.door'

  --states
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
