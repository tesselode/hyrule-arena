export Game = {
  enter: =>
    @world = bump.newWorld!
    @player = Player @world, 400, 300

  update: (dt) =>
    --update all instances
    for item in *@world\getItems!
      item\update dt

  keypressed: (key) =>
    for item in *@world\getItems!
      item\keypressed key if item.keypressed

  draw: =>
    --draw all instances
    for item in *@world\getItems!
      item\draw!
}
