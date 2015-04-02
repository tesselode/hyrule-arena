export Game = {
  enter: =>
    @instances = {}
    table.insert @instances, Player 400, 300

  update: (dt) =>
    --update all instances
    for k, v in pairs @instances
      if v.update
        v\update dt

  draw: =>
    --draw all instances
    for k, v in pairs @instances
      if v.draw
        v\draw!
}
