export class Player extends Physical
  new: (world, x, y) =>
    super world, x, y, 40, 40
    @acceleration = 2500
    @drag = 10
    @maxSpeed = 300
    @direction = 0
    @canShoot = true

    @filter = (other) =>
      if other.id == 'wall'
        return 'slide'
      else
        return false

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
    with @velocity
      .x = util.interpolate .x, 0, dt * @drag -- go from current vel to 0 at a rate of dt * 10
      .y = util.interpolate .y, 0, dt * @drag

    --limit speed
    if @velocity\len! > @maxSpeed
      @velocity = @velocity\normalized! * @maxSpeed

    --find the direction the player is facing
    if (love.keyboard.isDown 'left') or (love.keyboard.isDown 'right') or (love.keyboard.isDown 'up') or (love.keyboard.isDown 'down')
      @direction = math.atan2 @velocity.y, @velocity.x

    _, _, cols = super\update dt

    -- velocity resolution (weird stuff happens without it)
    for col in *cols
      @velocity.x = 0 if col.normal.x ~= 0 and col.normal.x ~= util.sign @velocity.x
      @velocity.y = 0 if col.normal.y ~= 0 and col.normal.y ~= util.sign @velocity.y

  keypressed: (key) =>
    --shooting
    if key == 'x'
      x, y = @world\getRect self
      Projectile @world, x + 20, y + 20, 10, 10, 800, @direction

  draw: =>
    super\draw!

    --debug stuff - shows which way the player is facing
    with love.graphics
      .setColor 255, 255, 255, 255
      .setLineWidth 3
      x, y = @world\getRect self
      .circle 'line', x + 20, y + 20, 20
      directionLine = vector.new(20, 0)\rotated(@direction)
      .line x + 20, y + 20, x + 20 + directionLine.x, y + 20 + directionLine.y
