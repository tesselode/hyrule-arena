export class Player extends Physical
  new: (world, x, y) =>
    super world, x, y, 40, 40

    --movement stuff
    @acceleration = 2500
    @drag = 8
    @maxSpeed = 300
    @direction = 0
    @attackRange = 40
    @knockback = false

    @swordHitbox =
      w: 40, h: 40
      drawAlpha: 0
      center: vector!

    --health and damage stuff
    @maxHealth = 10
    @health = @maxHealth
    @damage = 1
    @ghosting = false
    @ghostingTime = 1
    @ghostingVisible = true
    tick.recur (-> @ghostingVisible = not @ghostingVisible), .08

    --collision filter
    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return 'cross'

    --cosmetic
    @drawShadow = true

  update: (dt) =>
    if not @knockback
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

      --limit speed
      if @velocity\len! > @maxSpeed
        @velocity = @velocity\normalized! * @maxSpeed

      --find the direction the player is facing
      if dir ~= vector 0,0
        @direction = dir\normalized!\angleTo!

    --knockback movement
    if @knockback
      if @velocity\len! < 100
        @knockback = false

    cols = super\update dt

    -- velocity resolution (weird stuff happens without it)
    for col in *cols
      if col.other.__class == Wall
        @velocity.x = 0 if col.normal.x ~= 0 and col.normal.x ~= util.sign @velocity.x
        @velocity.y = 0 if col.normal.y ~= 0 and col.normal.y ~= util.sign @velocity.y


  attack: =>
    --full health beam
    if @health == @maxHealth
      Projectile @world, @getCenter!.x, @getCenter!.y, 10, 10, 800, @direction

    --stabbing
    with @swordHitbox
      .center = @getCenter! + vector(@attackRange, 0)\rotated(@direction)
      .drawAlpha = 255
      flux.to @swordHitbox, .5, drawAlpha: 0 --delete me when the game actually has graphics

      --deal damage to any enemies in range
      for item in *@world\queryRect .center.x - .w/2, @swordHitbox.center.y - .h/2, 40, 40
        if item.__class == Enemy or item.__class.__parent == Enemy
          if not item.inAir
            item\takeDamage self, @damage

  takeDamage: (other) =>
    if not @ghosting
      @health -= other.damage
      --knockback stuff
      knockbackVector = (@getCenter! - other\getCenter!)\normalized!
      @velocity = knockbackVector * 650
      @knockback = true
      @ghosting = true
      tick.delay (-> @ghosting = false), @ghostingTime

  draw: =>
    if (not @ghosting) or (@ghostingVisible)
      super\draw!

    --debug stuff - shows which way the player is facing
    with love.graphics
      .setColor 0, 0, 0, 255
      .setLineWidth 3
      x, y, w, h = @world\getRect self
      directionLine = vector(w/2, 0)\rotated(@direction)
      .line @getCenter!.x, @getCenter!.y, @getCenter!.x + directionLine.x, @getCenter!.y + directionLine.y

    --show range of sword attack (debugging)
    with @swordHitbox
      love.graphics.setColor 0, 0, 0, .drawAlpha
      love.graphics.rectangle 'fill', .center.x - .w/2, .center.y - .h/2, .w, .h
