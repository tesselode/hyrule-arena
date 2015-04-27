export class PlayerSpawnAnimation extends Common
  new: (@map) =>
    super!

    @active = false
    @position = vector!

    @shadowAlpha = 0

    @currentAnimation = animations.linkRunDown
    @animationTimer = 1
    @animationSpeed = 20

    @beamWidth = 0
    @beamAlpha = 255

    @fakeHealthY = -50

  start: =>
    @active = true

    @position = vector BASE_WIDTH / 2 - TILE_SIZE / 2, -50

    @shadowAlpha = 0

    @currentAnimation = animations.linkRunDown
    @animationTimer = 1
    @animationSpeed = 20

    @beamWidth = 0
    @beamAlpha = 255

    @fakeHealthY = -50

    @tween\to(@position, 1.5, {y: BASE_HEIGHT / 2 - TILE_SIZE / 2})\oncomplete(->
      @active = false
      @map\startGame!)
    @tween\to(self, 1.5, {shadowAlpha: 255, animationSpeed: 2})
    @tween\to(self, .2, {beamWidth: TILE_SIZE})
    @tween\to(self, .5, {beamAlpha: 0})\delay(1)
    @tween\to(self, 1.5, {fakeHealthY: 10})\ease('elasticinout')

  update: (dt) =>
    super dt

    if @active
      @animationTimer -= dt * @animationSpeed
      while @animationTimer <= 0
        @animationTimer += 1
        @spin!

  spin: =>
    with animations
      if @currentAnimation == .linkRunDown
        @currentAnimation = .linkRunLeft
      elseif @currentAnimation == .linkRunLeft
        @currentAnimation = .linkRunUp
      elseif @currentAnimation == .linkRunUp
        @currentAnimation = .linkRunRight
      elseif @currentAnimation == .linkRunRight
        @currentAnimation = .linkRunDown

  draw: =>
    if @active
      with love.graphics
        --draw beam
        .setColor 100, 100, 255, @beamAlpha
        .rectangle 'fill', BASE_WIDTH / 2 - @beamWidth / 2, 0, @beamWidth, BASE_HEIGHT / 2 + 10

        --draw shadow
        .setColor 255, 255, 255, @shadowAlpha
        .draw images.shadow, BASE_WIDTH / 2 - 1, BASE_HEIGHT / 2 - 1, 0, 1, 1, images.shadow\getWidth! / 2

        --draw link
        .setColor 255, 255, 255, 255
        @currentAnimation\draw images.linkSpriteSheet, @position.x, @position.y, 0, 1, 1, 8, 8
