export class Player extends Physical
  new: (world, x, y) =>
    super world, x, y, 40, 40
    @acceleration = 2500
    @drag = 8
    @maxSpeed = 300
    @direction = 0
    @canShoot = true
    @attackRange = 40

    @swordHitbox =
      w: 40, h: 40
      drawAlpha: 0
      center: vector.new!

    @maxHealth = 10
    @health = @maxHealth

    @ghostingTime = 0

    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return 'cross'

  update: (dt) =>
    --movement
    dir = vector!
    if love.keyboard.isDown 'left'
      @velocity.x -= @acceleration * dt
      dir.x = -1
    if love.keyboard.isDown 'right'
      @velocity.x += @acceleration * dt
      dir.x = 1
    if love.keyboard.isDown 'up'
      @velocity.y -= @acceleration * dt
      dir.y = -1
    if love.keyboard.isDown 'down'
      @velocity.y += @acceleration * dt
      dir.y = 1

    --drag
    with @velocity
      .x = util.interpolate .x, 0, dt * @drag -- go from current vel to 0 at a rate of dt * 10
      .y = util.interpolate .y, 0, dt * @drag

    --limit speed
    if @velocity\len! > @maxSpeed
      @velocity = @velocity\normalized! * @maxSpeed

    --find the direction the player is facing
    if dir ~= vector 0,0
      @direction = dir\normalized!\angleTo!

    cols = super\update dt

    -- velocity resolution (weird stuff happens without it)
    -- for col in *cols
    --   @velocity.x = 0 if col.normal.x ~= 0 and col.normal.x ~= util.sign @velocity.x
    --   @velocity.y = 0 if col.normal.y ~= 0 and col.normal.y ~= util.sign @velocity.y


  attack: =>
    --shooting
    x, y, w, h = @world\getRect self
    Projectile @world, x + w/2, y + h/2, 10, 10, 800, @direction

    --stabbing

    with @swordHitbox
      .center = vector.new(x + w/2, y + h/2) + vector.new(@attackRange, 0)\rotated(@direction)
      .drawAlpha = 255
      flux.to @swordHitbox, .5, drawAlpha: 0 --cosmetic debugging stuff

      --deal damage to any enemies in range
      for item in *@world\queryRect .center.x - .w/2, @swordHitbox.center.y - .h/2, 40, 40
        if item.__class == Enemy
          item\takeDamage self

  takeDamage: (other) =>
    knockback = (@getCenter! - other\getCenter!)\normalized!
    @velocity = knockback * 1000

  draw: =>
    super\draw!

    --debug stuff - shows which way the player is facing
    with love.graphics
      .setColor 255, 255, 255, 255
      .setLineWidth 3
      x, y, w, h = @world\getRect self
      .circle 'line', x + w/2, y + h/2, w/2
      directionLine = vector.new(20, 0)\rotated(@direction)
      .line x + w/2, y + h/2, x + w/2 + directionLine.x, y + h/2 + directionLine.y

    --show range of sword attack (debugging)
    with @swordHitbox
      love.graphics.setColor 255, 255, 255, .drawAlpha
      love.graphics.rectangle 'fill', .center.x - .w/2, .center.y - .h/2, .w, .h
