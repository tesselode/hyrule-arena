export class Enemy extends Physical
  new: (world, @map, x, y) =>
    super world, x, y, 40, 40

    @isEnemy = true
    @inAir = false
    @knockback = false
    @health = 3
    @damage = 1

    --collision filter
    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return 'cross'

    @drawShadow = true

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
        --damage the player
        if @inAir == false and other.__class == Player
          other\takeDamage self

    return collisions

  takeDamage: (other, damage) =>
    if other.__class == Player
      @health -= damage
      --knockback movement
      @knockback = true
      @velocityPrev = @velocity
      @velocity = vector.new(800, 0)\rotated(other.direction)
