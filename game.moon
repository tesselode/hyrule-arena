export Game = {
  enter: =>
    @world = bump.newWorld!
    @instances = {}
    table.insert @instances, Player 400, 300

  update: (dt) =>
    --update all instances
    for k, v in pairs @instances
      if v.update
        v\update dt

  keypressed: (key) =>
    for k, v in pairs @instances
      if v.keypressed
        v\keypressed key

  draw: =>
    --draw all instances
    for k, v in pairs @instances
      if v.draw
        v\draw!
}
