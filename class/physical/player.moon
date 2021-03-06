export class Player extends Physical
  new: (state, x, y) =>
    super state, x, y, 10, 10

    --movement stuff
    @acceleration = 2000
    @drag = 8
    @maxSpeed = 150
    @direction = math.pi / 2
    @knockback = false

    --attack stuff
    @canSwing = true
    @canSwingTime = .2
    @attackRange = 25
    @swordHitbox =
      w: TILE_SIZE, h: TILE_SIZE
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
    @sprite = 'animation'
    @shadowVisible = true
    @depth += 200
    @rageParticles = love.graphics.newParticleSystem images.particle, 100
    with @rageParticles
      \setColors 255, 255, 0, 255, 255, 255, 0, 0
      \setEmissionRate 20
      \setParticleLifetime .2, .3
      \setSpeed 50, 60
      \setSpread 2 * math.pi
      \start!

  update: (dt) =>
    if @canSwing and not @knockback
      -- limit speed
      if @velocity\len! > @maxSpeed
        @velocity = @velocity\normalized! * @maxSpeed

    -- knockback movement
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

    with @rageParticles
      if @health < 4
        \start!
        \setPosition @getCenter!.x, @getCenter!.y
      else
        \stop!
      \update dt

  attack: =>
    --full health beam
    if @health < 4 and @canShoot
      SwordBeam @state, @getCenter!.x, @getCenter!.y, @direction
      @canShoot = false
      @timer\delay (-> @canShoot = true), @canShootTime
      sounds.beam\play!

    --stabbing
    if @canSwing
      with @swordHitbox
        .center = @getCenter! + vector(@attackRange, 0)\rotated(@direction)
        .drawAlpha = 255
        @tween\to @swordHitbox, .5, drawAlpha: 0 --delete me when the game actually has graphics

        --deal damage to any enemies in range
        for item in *@state.world\queryRect .center.x - .w/2, @swordHitbox.center.y - .h/2, .w, .h
          if item.__class == Enemy or item.__class.__parent == Enemy
            --if not item.inAir
            item\takeDamage self, @damage

      --delay before being able to stab again
      @canSwing = false
      @drag = 1000

      --cosmetic stuff
      if @direction == 0
        @sprite = 'stabRight'
      elseif @direction == math.pi
        @sprite = 'stabLeft'
      elseif @direction == math.pi / 2
        @sprite = 'stabDown'
      elseif @direction == -math.pi / 2
        @sprite = 'stabUp'

      --spark animation
      positionVector = vector(@getCenter!.x, @getCenter!.y) + vector(16, 0)\rotated(@direction)
      Whoosh @state, positionVector.x, positionVector.y, @direction

      @timer\delay (->
          @canSwing = true
          @drag = 8
          @sprite = 'animation'),
        @canSwingTime

      --sounds
      --sounds[util.trandom({'swing1', 'swing2', 'swing3'})]\play!
      sounds.swing\play!
      if love.math.random(1, 3) == 3 then
        sounds[util.trandom({'voice_swing', 'voice_swing2'})]\play!

  takeDamage: (other) =>
    if not @ghosting
      @health -= other.damage
      --knockback stuff
      knockbackVector = (@getCenter! - other\getCenter!)\normalized!
      @velocity = knockbackVector * 325
      @knockback = true
      @ghosting = true
      @timer\delay (-> @ghosting = false), @ghostingTime

      --sounds
      sounds.damage\play!
      if @health < 1
        sounds.voice_death\play!
      elseif love.math.random(1, 2) == 2 then
        sounds.voice_damage\play!

  draw: =>
    --if (not @ghosting) or (@ghostingVisible)
      --super\draw!

    --draw sprite/animations
    if (not @ghosting) or (@ghostingVisible)
      with love.graphics
        .setColor 255, 255, 255, 255
        .draw @rageParticles

        --game over background
        if @health < 1
          .setColor 255, 0, 0, 255
          .rectangle 'fill', @getCenter!.x - 10000, @getCenter!.y - 10000, 20000, 20000

        if @health < 1
          .setColor 0, 0, 0, 255
        elseif @health < 4
          .setColor 255, 150, 150, 255
        else
          .setColor 255, 255, 255, 255
        x, y, w, h = @state.world\getRect self

        if @sprite == 'animation'
          if @direction == 0
            animations.linkRunRight\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
          elseif @direction == math.pi
            animations.linkRunLeft\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
          elseif @direction == math.pi / 2
            animations.linkRunDown\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
          else
            animations.linkRunUp\draw images.linkSpriteSheet, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
        elseif @sprite == 'stabRight'
          .draw images.linkStabRight, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
        elseif @sprite == 'stabLeft'
          .draw images.linkStabRight, @getCenter!.x, @getCenter!.y, 0, -1, 1, 16, 16
        elseif @sprite == 'stabUp'
          .draw images.linkStabUp, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
        elseif @sprite == 'stabDown'
          .draw images.linkStabDown, @getCenter!.x, @getCenter!.y, 0, 1, 1, 16, 16
