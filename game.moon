export Game = {
  enter: =>
    @world = bump.newWorld!
    @map = Map @world
    @camera = camera.new!
    @map\addEnemy Octorok, 300, 300

    -- with @map
    --   \addWall 200, 200, 100, 100
    --   \addEnemy Tektite, 600, 500
    --   --game border (temporary)
    --   \addWall 0, 0, 1280, 20
    --   \addWall 0, 700, 1280, 20
    --   \addWall 0, 20, 20, 680
    --   \addWall 1260, 20, 20, 680

    --temporary code so I can see shadows
    love.graphics.setBackgroundColor 100, 100, 100, 255

  update: (dt) =>
    --update all instances
    for item in *@world\getItems!
      item\update dt if item.update

    @map\update dt

    x, y = @map.currentRoom\getWorldCenter!
    @camera\lookAt util.interpolate(@camera.x, x, dt * 7), util.interpolate(@camera.y, y, dt * 7)

  keypressed: (key) =>
    if key == 'escape' -- change this later
      love.event.quit!

    if key == 'x'
      @map.player\attack!

  draw: =>
    @camera\attach!

    --draw all instances
    -- for item in *@world\getItems!
    --   item\draw! if item.draw

    @map\draw!

    @camera\detach!

    -- gui would be drawn here
}
