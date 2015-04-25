export class Controller
  isDown = love.keyboard.isDown

  -- convenience table for directional vectors
  directions =
    right: vector  1, 0
    down:  vector  0, 1
    left:  vector -1, 0
    up:    vector  0,-1


  new: (@player, @gamepad) =>
    @directions = {} -- table of directions that are being held down
    -- only the first and second are used, the third and the rest are ignored

  update: (dt) =>
    with @player
      if @directions[1] -- movement direction
        .velocity += .acceleration * @directions[1] * dt
        .direction = @directions[1]\normalized!\angleTo!

        if @directions[2] -- strafing direction
          .velocity += .acceleration * @directions[2] * dt
      else
        with @player.velocity
          .x = util.interpolate .x, 0, 10 * dt
          .y = util.interpolate .y, 0, 10 * dt

  keypressed: (key) =>
    if directions[key]
      table.insert @directions, directions[key]

    if key == 'x'
      @player\attack!

  keyreleased: (key) =>
    for i,dir in ipairs @directions
      if dir == directions[key]
        table.remove @directions, i
        return
