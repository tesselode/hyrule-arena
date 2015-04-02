export Game = {}

Game.enter =  =>
  @instance = {}
  table.insert @instance, Player 400, 300

Game.update = (dt) =>
  for k, v in pairs @instance
    if v.update
      v\update dt

Game.draw =  =>
  for k, v in pairs @instance
    if v.draw
      v\draw!
