export class Physical
  new: (@x, @y, @w, @h) =>
    @velocity = vector.new 0, 0

  update: (dt) =>
    @x += @velocity.x * dt
    @y += @velocity.y * dt
