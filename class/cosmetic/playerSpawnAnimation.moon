export class PlayerSpawnAnimation extends Common
  new: (@map) =>
    super!

    @shouldDraw = false
    @position = vector!
    @shadowAlpha = 0

  start: =>
    @position = vector 512, -50
    @shouldDraw = true
    @tween\to(self, 1.5, {shadowAlpha: 255})
    @tween\to(@position, 1.5, {y: 288})\oncomplete(->
      @shouldDraw = false
      @map\startGame!)

  draw: =>
    if @shouldDraw
      with love.graphics
        --draw shadow
        .setColor 255, 255, 255, @shadowAlpha
        .draw images.shadow, 512, 288, 0, 1, 1, images.shadow\getWidth! / 2

        --draw link
        .setColor 255, 255, 255, 255
        animations.linkRunDown\draw images.linkSpriteSheet, @position.x, @position.y, 0, 2, 2, 16, 16
