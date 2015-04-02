export class Projectile extends Physical
  new: (x, y, w, h, speed, dir) =>
    super x, y, w, h
    @velocity = vector.new(speed, 0)\rotated(dir)
