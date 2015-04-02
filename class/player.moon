export class Player extends Physical
  new: (x, y) =>
    super x, y, 40, 40
    @acceleration = 2500
    @drag = 1000
    @maxSpeed = 300
    @direction = 0

  update: (dt) =>
    --movement
    if love.keyboard.isDown 'left'
      @velocity.x -= @acceleration * dt
    if love.keyboard.isDown 'right'
      @velocity.x += @acceleration * dt
    if love.keyboard.isDown 'up'
      @velocity.y -= @acceleration * dt
    if love.keyboard.isDown 'down'
      @velocity.y += @acceleration * dt

    --drag
    if @velocity.x < 0
      @velocity.x += @drag * dt
      if @velocity.x > 0
        @velocity.x = 0

    if @velocity.x > 0
      @velocity.x -= @drag * dt
      if @velocity.x < 0
        @velocity.x = 0

    if @velocity.y < 0
      @velocity.y += @drag * dt
      if @velocity.y > 0
        @velocity.y = 0

    if @velocity.y > 0
      @velocity.y -= @drag * dt
      if @velocity.y < 0
        @velocity.y = 0

    --limit speed
    if @velocity\len! > @maxSpeed
      @velocity = @velocity\normalized! * @maxSpeed

    --find the direction the player is facing
    if (love.keyboard.isDown 'left') or (love.keyboard.isDown 'right') or (love.keyboard.isDown 'up') or (love.keyboard.isDown 'down')
      @direction = math.atan2 @velocity.y, @velocity.x

    super\update dt

  draw: =>
    super\draw!

    --debug stuff - shows which way the player is facing
    with love.graphics
      .setColor 255, 255, 255, 255
      .setLineWidth 3
      x, y = gamestate.current!.world\getRect self
      .circle 'line', x + 20, y + 20, 20
      directionLine = vector.new(20, 0)\rotated(@direction)
      .line x + 20, y + 20, x + 20 + directionLine.x, y + 20 + directionLine.y
