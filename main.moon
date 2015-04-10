love.load =  ->
  export * -- globalizes all variables in this scope

  -- libraries
  vector = require 'lib.hump.vector'
  gamestate = require 'lib.hump.gamestate'
  camera = require 'lib.hump.camera'
  bump = require 'lib.bump'
  tick = require 'lib.tick'
  flux = require 'lib.flux'
  anim8 = require 'lib.anim8'
  util = require 'lib.util'

  -- use nearest when scaling up, for pixelation
  love.graphics.setDefaultFilter 'linear', 'nearest'

  -- images
  local newImage
  newImage = love.graphics.newImage

  images =
    linkSpriteSheet: newImage 'images/female link oga 32px.png'
    shadow: newImage 'images/shadow.png'
    gemBlue: newImage 'images/blue gem.png'
    heartEmpty: newImage 'images/placeholder/heartEmpty.png'
    heartFull: newImage 'images/placeholder/heartFull.png'

  -- link animations
  local g
  g = anim8.newGrid 32, 32, images.linkSpriteSheet\getWidth!, images.linkSpriteSheet\getHeight!

  animations =
    linkRunUp: anim8.newAnimation g('1-4', 1), 0.1
    linkRunRight: anim8.newAnimation g('1-4', 2), 0.1
    linkRunLeft: anim8.newAnimation(g('1-4', 2), 0.1)\flipH!
    linkRunDown: anim8.newAnimation g('1-4', 3), 0.1

  -- classes
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

  -- states
  require 'game'

  with gamestate
    .registerEvents!
    .switch Game

love.update = (dt) ->
  -- update some libraries
  tick.update dt
  flux.update dt

love.keypressed = (key) ->
  if key == 'escape' -- change this later
    love.event.quit!
