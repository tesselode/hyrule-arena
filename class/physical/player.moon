export class Player extends Physical
  new: (state, x, y) =>
    super state, x, y, 32, 32

    --movement stuff
    @acceleration = 4000
    @drag = 8
    @maxSpeed = 300
    @direction = math.pi / 2
    @knockback = false

    --attack stuff
    @canSwing = true
    @canSwingTime = .1
    @attackRange = 50
    @swordHitbox =
      w: 32, h: 32
      drawAlpha: 0
      center: vector!
    @canShoot = true
    @canShootTime = .75

    --health and damage stuff
    @maxHealth = 10
    @health = @maxHealth
    @damage = 1
    @ghosting = false
    @ghostingTime = 1
    @ghostingVisible = true
    @timer\recur (-> @ghostingVisible = not @ghostingVisible), .08

    --collision filter
    @filter = (other) =>
      if other.__class == Wall or (other.__class == Door and not other.isOpen)
        return 'slide'
      else
        return 'cross'

    --cosmetic
    @shadowVisible = true
    @depth += 100

  update: (dt) =>
    if not @knockback
      --movement
      if love.keyboard.isDown 'left'
        if not love.keyboard.isDown 'right'
          @velocity.x -= @acceleration * dt
        if not love.keyboard.isDown 'up', 'down'
          @direction = math.pi

      if love.keyboard.isDown 'right'
        if not love.keyboard.isDown 'left'
          @velocity.x += @acceleration * dt
        if not love.keyboard.isDown 'up', 'down'
          @direction = 0

      if love.keyboard.isDown 'up'
        if not love.keyboard.isDown 'down'
          @velocity.y -= @acceleration * dt
        if not love.keyboard.isDown 'left', 'right'
          @direction = -math.pi / 2

      if love.keyboard.isDown 'down'
        if not love.keyboard.isDown 'up'
          @velocity.y += @acceleration * dt
        if not love.keyboard.isDown 'left', 'right'
          @direction = math.pi / 2

      --limit speed
      if @velocity\len! > @maxSpeed
        @velocity = @velocity\normalized! * @maxSpeed

    --knockback movement
    if @knockback
      if @velocity\len! < 100
        @knockback = false

    cols = super dt

    -- velocity resolution (weird stuff happens without it)
    for col in *cols
      if col.other.__class == Wall
        @velocity.x = 0 if col.normal.x ~= 0 and col.normal.x ~= util.sign @velocity.x
        @velocity.y = 0 if col.normal.y ~= 0 and col.normal.y ~= util.sign @velocity.y

    --update animation
    with animations
      if @velocity\len! < 20
        .linkRunUp\gotoFrame 1
        .linkRunRight\gotoFrame 1
        .linkRunLeft\gotoFrame 1
        .linkRunDown\gotoFrame 1
      .linkRunUp\update dt * ((150 + .5 * @velocity\len!) / @maxSpeed)
      .linkRunRight\update dt * ((150 + .5 * @velocity\len!) / @maxSpeed)
      .linkRunLeft\update dt * ((150 + .5 * @velocity\len!) / @maxSpeed)
      .linkRunDown\update dt * ((150 + .5 * @velocity\len!) / @maxSpeed)

  attack: =>
    --full health beam
    if @health == @maxHealth and @canShoot
      Projectile @state, @getCenter!.x, @getCenter!.y, 10, 10, 800, @direction
      @canShoot = false
      @timer\delay (-> @canShoot = true), @canShootTime

    --stabbing
    if @canSwing
      with @swordHitbox
        .center = @getCenter! + vector(@attackRange, 0)\rotated(@direction)
        .drawAlpha = 255
        @tween\to @swordHitbox, .5, drawAlpha: 0 --delete me when the game actually has graphics

        --deal damage to any enemies in range
        for item in *@state.world\queryRect .center.x - .w/2, @swordHitbox.center.y - .h/2, 40, 40
          if item.__class == Enemy or item.__class.__parent == Enemy
            --if not item.inAir
            item\takeDamage self, @damage

      --delay before being able to stab again
      @canSwing = false
      @timer\delay (-> @canSwing = true), @canSwingTime

  takeDamage: (other) =>
    if not @ghosting
      @health -= other.damage
      --knockback stuff
      knockbackVector = (@getCenter! - other\getCenter!)\normalized!
      @velocity = knockbackVector * 650
      @knockback = true
      @ghosting = true
      @timer\delay (-> @ghosting = false), @ghostingTime

  draw: =>
    --if (not @ghosting) or (@ghostingVisible)
      --super\draw!

    --draw sprite/animations
    if (not @ghosting) or (@ghostingVisible)
      with love.graphics
        .setColor 255, 255, 255, 255
        x, y, w, h = @state.world\getRect self
        if @direction == 0
          animations.linkRunRight\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 2, 2, 16, 16
        elseif @direction == math.pi
          animations.linkRunLeft\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 2, 2, 16, 16
        elseif @direction == math.pi / 2
          animations.linkRunDown\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 2, 2, 16, 16
        else
          animations.linkRunUp\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 2, 2, 16, 16

    --debug stuff
    if true
      --show which way the player is facing
      if false
        with love.graphics
          .setColor 0, 0, 0, 255
          .setLineWidth 3
          x, y, w, h = @state.world\getRect self
          directionLine = vector(w/2, 0)\rotated(@direction)
          .line @getCenter!.x, @getCenter!.y, @getCenter!.x + directionLine.x, @getCenter!.y + directionLine.y

      --show range of sword attack
      with @swordHitbox
        love.graphics.setColor 0, 0, 0, .drawAlpha
        love.graphics.rectangle 'fill', .center.x - .w/2, .center.y - .h/2, .w, .h