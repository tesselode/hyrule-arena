export Game =
  enter: =>
    @instances = {}
    table.insert @instances, Player 400, 300

  update: (dt) =>
    for k, v in pairs @instances
      if v.update
        v\update dt

  draw: =>
    for k, v in pairs @instances
      if v.draw
        v\draw!
