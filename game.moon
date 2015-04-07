export Game = {
  enter: =>
    @camera = camera.new!
    @map = Map!

    --temporary code so I can see shadows
    love.graphics.setBackgroundColor 100, 100, 100, 255

  update: (dt) =>
    @map\update dt

    --update camera
    x, y = @map.currentRoom\getWorldCenter!
    @camera\lookAt util.interpolate(@camera.x, x, dt * 7), util.interpolate(@camera.y, y, dt * 7)

  keypressed: (key) =>
    if key == 'x'
      @map.player\attack!

  draw: =>
    --draw the game world
    @camera\attach!
    @map\draw!
    @camera\detach!

    -- gui would be drawn here
}
