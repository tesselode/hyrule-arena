export class Enemy extends Physical
  painVibration = 1

  new: (state, x, y) =>
    super state, x, y, TILE_SIZE - 2, TILE_SIZE - 2

    @isEnemy = true
    @inAir = false
    @knockback = false
    @health = 3
    @damage = 1
    @gemAmount = 5
    @score = 100
    @shadowVisible = true
    @pain = 0

    --collision filter
    @filter = (other) =>
      if other.__class == Wall or other.__class == Door or other.__class.__parent == Enemy
        return 'slide'
      else
        return 'cross'

    @depth += 100

  update: (dt) =>
    --knockback movement
    if @knockback
      @drag = 8
      if @velocity\len! < 50
        @knockback = false
        @drag = 0
        @velocity = @velocityPrev

    --at this point this is a death animation
    if @health <= 0
      @delete = true

    collisions = super dt
    if @health > 0
      for col in *collisions
        other = col.other
        --bounce off of walls
        if other.__class == Wall
          @velocity = -@velocity
        --damage the player
        if @inAir == false and other.__class == Player
          other\takeDamage self

    return collisions

  shake: =>

  takeDamage: (other, damage) =>
    @health -= damage
    if other.__class.__parent == Projectile or other.__class == Player
      --knockback movement
      @knockback = true
      @velocityPrev = @velocity
      @velocity = vector.new(400, 0)\rotated(other.direction)

      --sounds
      sounds.damage2\play!

      -- tween the pain variable, some things depend on it
      @pain = 1
      @tween\to self, 0.5, pain: 0

  onDelete: =>
    --give the player poins
    @state.gameFlow.score += @score * @state.gameFlow.multiplier
    --spawn gems when dead
    for i = 1, @gemAmount
      Gem @state, @getCenter!.x, @getCenter!.y

  drawPainEffects: (func) =>
    -- apply pain vibration + shader
    with love.graphics
      vx = love.math.random -@pain * painVibration, @pain * painVibration
      vy = love.math.random -@pain * painVibration, @pain * painVibration
      shaders.pain\send 'magnitude', @pain

      .push 'all'
      .setShader shaders.pain
      .translate vx, vy
      func!
      .pop!

  draw: =>
    @drawPainEffects -> super!
