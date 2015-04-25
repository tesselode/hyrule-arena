export class Controller
  isDown = love.keyboard.isDown

  -- convenience table for directional vectors
  directions =
    right: vector  1, 0
    down:  vector  0, 1
    left:  vector -1, 0
    up:    vector  0,-1

    -- for gamepad dpad buttons
    dpright: vector  1, 0
    dpdown:  vector  0, 1
    dpleft:  vector -1, 0
    dpup:    vector  0,-1


  new: (@player, @gamepad) =>
    @directions = {} -- table of directions that are being held down
    -- only the first and second are used, the third and the rest are ignored

    -- in essence, here's how this shit works
    -- let's say you hold the up key, then the left key
    -- up and left directional vectors (see the "directions" table above) are added to @directions in that order
    -- the up direction is first and treated as the movement direction, and the facing direction
    -- the left direction is second and treated as the secondary strafing direction

    -- so let's say you let go of the up direction
    -- the up direction is found and removed from the @directions table
    -- then the left direction is pushed up front and is treated as the primary movement direction
    -- and, by effect, you start moving left

    -- so on and so forth when you then decide to press down, you start strafing down
    -- i'm so happy i figured this out

  update: (dt) =>
    with @player
      if @directions[1] -- movement direction
        .velocity += .acceleration * @directions[1] * dt
        .direction = @directions[1]\normalized!\angleTo!

        if @directions[2] -- strafing direction
          .velocity += .acceleration * @directions[2] * dt
      else
        -- if there are no directions, slow down
        drag = .drag
        with @player.velocity
          .x = util.interpolate .x, 0, drag * dt
          .y = util.interpolate .y, 0, drag * dt

  addDirection: (dirName) =>
    -- "we are now trying to move in this direction"
    @removeDirection dirName -- so we don't add a direction multiple times

    if directions[dirName]
      table.insert @directions, directions[dirName]

  removeDirection: (dirName) =>
    -- "we have stopped trying to move in this direction"
    for i,dir in ipairs @directions
      if dir == directions[dirName]
        table.remove @directions, i
        return

  keypressed: (key) =>
    @addDirection key

    if key == 'x'
      @player\attack!

  keyreleased: (key) =>
    @removeDirection key

  gamepadpressed: (gamepad, button) =>
    if gamepad == @gamepad
      switch button
        when 'a'
          @player\attack!
        else
          @addDirection button

  gamepadreleased: (gamepad, button) =>
    if gamepad == @gamepad
      @removeDirection button

  gamepadaxis: (gamepad, axis, value) =>
    print(axis, value)
    if gamepad == @gamepad
      switch axis
        when 'leftx','rightx'
          if value < -0.3
            @addDirection 'left'
          elseif value > 0.3
            @addDirection 'right'
          else
            @removeDirection 'left'
            @removeDirection 'right'

        when 'lefty','righty'
          if value < -0.3
            @addDirection 'up'
          elseif value > 0.3
            @addDirection 'down'
          else
            @removeDirection 'up'
            @removeDirection 'down'
