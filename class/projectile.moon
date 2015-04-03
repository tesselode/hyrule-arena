export class Projectile extends Physical
  new: (world, x, y, w, h, speed, dir) =>
    super world, x, y, w, h
    @velocity = vector.new(speed, 0)\rotated(dir)
    return self
