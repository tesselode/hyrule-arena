export Game = {
  enter: =>
    @world = bump.newWorld!
    @player = Player @world, 400, 300
    @enemy = Enemy @world, 600, 500
    @map = Map @world

    @map\addWall 200, 200, 100, 100

  update: (dt) =>
    --update all instances
    for item in *@world\getItems!
      item\update dt if item.update

  keypressed: (key) =>
    if key == 'escape' -- change this later
      love.event.quit!

    for item in *@world\getItems!
      item\keypressed key if item.keypressed

  draw: =>
    --draw all instances
    for item in *@world\getItems!
      item\draw! if item.draw
}
