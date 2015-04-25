love.load =  ->
  export * -- globalizes all variables in this scope

  -- constants
  BASE_WIDTH = 384
  BASE_HEIGHT = 216
  TILE_SIZE = 16

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
    linkSpriteSheet: newImage 'images/link/link.png'
    linkStabUp: newImage 'images/link/linkStabUp.png'
    linkStabRight: newImage 'images/link/linkStabRight.png'
    linkStabDown: newImage 'images/link/linkStabDown.png'
    shadow: newImage 'images/shadow.png'
    gemBlue: newImage 'images/blue gem.png'
    heartEmpty: newImage 'images/heartEmptySmall.png'
    heartFull: newImage 'images/heartFullSmall.png'
    octorok: newImage 'images/octorok.png'
    environment: newImage 'images/environment.png'
    whoosh: newImage 'images/whoosh.png'
    swordBeam: newImage 'images/swordBeam.png'
    blob: newImage 'images/blob.png'

  local newSource
  newSource = love.audio.newSource
  sounds =
    damage: newSource 'audio/damage.wav', 'static'
    damage2: newSource 'audio/damage2.wav', 'static'
    rupee: newSource 'audio/rupee.wav', 'static'
    swing: newSource 'audio/sword.wav', 'static'
    voice_damage: newSource 'audio/voice_damage.wav', 'static'
    voice_death: newSource 'audio/voice_death.wav', 'static'
    voice_swing: newSource 'audio/voice_swing.wav', 'static'
    voice_swing2: newSource 'audio/voice_swing2.wav', 'static'

  fonts =
    title: love.graphics.newFont 'images/fonts/visitor1.ttf', 30
    menu: love.graphics.newFont 'images/fonts/visitor1.ttf', 10

  -- link animations
  local g
  g = anim8.newGrid 32, 32, images.linkSpriteSheet\getWidth!, images.linkSpriteSheet\getHeight!

  animations =
    linkRunUp: anim8.newAnimation g('1-4', 1), 0.1
    linkRunRight: anim8.newAnimation g('1-4', 2), 0.1
    linkRunLeft: anim8.newAnimation(g('1-4', 2), 0.1)\flipH!
    linkRunDown: anim8.newAnimation g('1-4', 3), 0.1

  local roomTile
  roomTile = (x, y, w = 1, h = 1) ->
    love.graphics.newQuad (x - 1) * 16, (y - 1) * 16,
      16 * w, 16 * h,
      images.environment\getDimensions!

  roomQuads =
    grave1: roomTile 1, 3
    grave2: roomTile 2, 3
    grave3: roomTile 3, 3
    grave4: roomTile 4, 3
    grave5: roomTile 5, 3
    well: roomTile 1, 6
    statue1: roomTile 10, 8
    statue2: roomTile 11, 8
    statue3: roomTile 12, 8

    floor: roomTile 9, 3, 2, 2
    wall: roomTile 9, 1, 2, 2

  -- classes
  require 'class.common'
  require 'class.game'
  require 'class.physical.physical'
  require 'class.physical.wall'
  require 'class.physical.projectile'
  require 'class.physical.gem'
  require 'class.physical.player'
  require 'class.physical.swordBeam'
  require 'class.physical.enemies.enemy'
  require 'class.physical.enemies.follower'
  require 'class.physical.enemies.octorok'
  require 'class.physical.enemies.tektite'
  require 'class.map'
  require 'class.room'
  require 'class.physical.door'
  require 'class.cosmetic.hud'
  require 'class.cosmetic.playerSpawnAnimation'
  require 'class.cosmetic.irisInAnimation'
  require 'class.menu.titleMenu'
  require 'class.menu.gameOverMenu'
  require 'class.cosmetic.whoosh'

  currentState = Game!

  -- temporary code so I can see shadows
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
