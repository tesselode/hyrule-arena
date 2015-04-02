export Game =
  enter: =>
    @instance = {}
    table.insert @instance, Player 400, 300

  update: (dt) =>
    for k, v in pairs @instance
      if v.update
        v\update dt

  draw: =>
    for k, v in pairs @instance
      if v.draw
        v\draw!
