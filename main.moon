love.load =  ->
  export * -- globalizes all variables in this scope

  -- libraries
  vector = require 'lib.hump.vector'
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
    linkSpriteSheet: newImage 'images/link.png'
    shadow: newImage 'images/shadow.png'
    gemBlue: newImage 'images/blue gem.png'
    heartEmpty: newImage 'images/heartEmpty.png'
    heartFull: newImage 'images/heartFull.png'

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
  require 'class.game'
  require 'class.physical.physical'
  require 'class.physical.wall'
  require 'class.physical.projectile'
  require 'class.physical.gem'
  require 'class.physical.player'
  require 'class.physical.enemies.enemy'
  require 'class.physical.enemies.follower'
  require 'class.physical.enemies.octorok'
  require 'class.physical.enemies.tektite'
  require 'class.map'
  require 'class.room'
  require 'class.physical.door'
  require 'class.cosmetic.playerSpawnAnimation'
  require 'class.cosmetic.irisInAnimation'

  currentState = Game!

  --temporary code so I can see shadows
  love.graphics.setBackgroundColor 100, 100, 100, 255

love.update = (dt) ->
  -- update some libraries
  tick.update dt
  flux.update dt

  currentState\update dt

love.keypressed = (key) ->
  if key == 'escape' -- change this later
    love.event.quit!

  currentState\keypressed key

love.draw = ->
  currentState\draw!
