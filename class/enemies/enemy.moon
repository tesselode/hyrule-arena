export class Enemy extends Physical
  new: (world, @map, x, y) =>
    super world, x, y, 40, 40

    @velocity = vector!
    @knockback = false
    @drag = 8

    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return 'cross'

  update: (dt) =>
    --knockback movement
    if @knockback
      --drag
      with @velocity
        .x = util.interpolate .x, 0, dt * @drag -- go from current vel to 0 at a rate of dt * 10
        .y = util.interpolate .y, 0, dt * @drag
      if math.abs(@velocity\len!) < 10
        @knockback = false

    collisions = super dt
    for col in *collisions
      other = col.other
      --damage the player
      if other.__class == Player
        other\takeDamage self

    return collisions

  takeDamage: (other) =>
    if other.__class == Player
      --knockback movement
      @knockback = true
      @velocity = vector.new(1000, 0)\rotated(other.direction)

  draw: =>
    super\draw!
