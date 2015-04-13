export class Game extends Common
  new: =>
    @map = Map self

    @camera = {}
    with @camera
      .main = camera.new!
      .main\zoomTo love.graphics.getHeight! / 576
      .map = camera.new!

    --cosmetic stuff
    @irisInCanvas = love.graphics.newCanvas 1024, 576
    @irisInRadius = 2000

    --temporary code so I can see shadows
    love.graphics.setBackgroundColor 100, 100, 100, 255

  update: (dt) =>
    @map\update dt

    --update camera
    x, y = @map.currentRoom\getWorldCenter!
    @camera.map\lookAt util.interpolate(@camera.map.x, x, dt * 7), util.interpolate(@camera.map.y, y, dt * 7)

  keypressed: (key) =>
    --controls
    if key == 'x'
      @map.player\attack!

  draw: =>
    --render iris in transition
    if @map.gameStarted
      with love.graphics
        @irisInCanvas\clear 0, 0, 0, 255
        @irisInCanvas\renderTo(->
          cameraX, cameraY = @camera.map\pos!
          playerX, playerY = @map.player\getCenter!.x, @map.player\getCenter!.y
          .setColor 255, 255, 255, 255
          .circle 'fill', playerX - cameraX + 512, playerY - cameraY + 288, @irisInRadius)


    @camera.main\attach!

    --draw the game world
    @camera.map\draw(->
      @map\draw!)

    --gui stuff
    topLeftX, topLeftY = @camera.main\worldCoords 0, 0
    if @map.gameStarted
      for i = 1, @map.player.maxHealth
        with love.graphics
          .setColor 255, 255, 255, 255
          if i > @map.player.health
            .draw images.heartEmpty, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5
          else
            .draw images.heartFull, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5

    --render iris in transition
    if @map.gameStarted
      with love.graphics
        .setBlendMode 'multiplicative'
        .setColor 255, 255, 255, 255
        .draw @irisInCanvas, topLeftX, topLeftY
        .setBlendMode 'alpha'

    @camera.main\detach!
