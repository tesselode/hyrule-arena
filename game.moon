export Game = {
  enter: =>
    @mainCamera = camera.new!
    @mainCamera\zoomTo love.graphics.getHeight! / 576

    @map = Map!
    @mapCamera = camera.new!

    --temporary code so I can see shadows
    love.graphics.setBackgroundColor 100, 100, 100, 255

  update: (dt) =>
    @map\update dt

    --update camera
    x, y = @map.currentRoom\getWorldCenter!
    @mapCamera\lookAt util.interpolate(@mapCamera.x, x, dt * 7), util.interpolate(@mapCamera.y, y, dt * 7)

  keypressed: (key) =>
    if key == 'x'
      @map.player\attack!

  draw: =>
    @mainCamera\attach!

    --draw the game world
    @mapCamera\attach!
    @map\draw!
    @mapCamera\detach!

    --gui stuff
    for i = 1, @map.player.maxHealth
      topLeftX, topLeftY = @mainCamera\worldCoords 0, 0
      with love.graphics
        .setColor 255, 255, 255, 255
        if i > @map.player.health
          .draw images.heartEmpty, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5
        else
          .draw images.heartFull, topLeftX + 10 + (i - 1) * 30, topLeftY + 10, 0, 1.5, 1.5

    @mainCamera\detach!
}
