export Game = {
  enter: =>
    @world = bump.newWorld!
    @map = Map @world

    with @map
      \addWall 200, 200, 100, 100
      \addEnemy 600, 500

  update: (dt) =>
    --update all instances
    for item in *@world\getItems!
      item\update dt if item.update

  keypressed: (key) =>
    if key == 'escape' -- change this later
      love.event.quit!

    if key == 'x'
      @map.player\attack!

  draw: =>
    --draw all instances
    for item in *@world\getItems!
      item\draw! if item.draw
}
