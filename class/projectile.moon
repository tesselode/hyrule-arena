export class Projectile extends Physical
  new: (world, x, y, w, h, speed, dir) =>
    super world, x, y, w, h

    @velocity = vector.new(speed, 0)\rotated(dir)

    @damage = 1

    @shadowVisible = false

  update: (dt) =>
    --destroy after hitting a wall
    cols = super dt
    for col in *cols
      if col.other.__class == Wall
        self.delete = true
      if col.other.__class.__parent == Enemy
        col.other\takeDamage self, @damage
        self.delete = true
