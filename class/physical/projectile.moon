export class Projectile extends Physical
  new: (state, x, y, w, h, speed, dir) =>
    super state, x - w/2, y - h/2, w, h

    @velocity = vector.new(speed, 0)\rotated(dir)

    @damage = 1

    @shadowVisible = false

  update: (dt) =>
    cols = super dt

    for col in *cols
      --destroy after hitting a wall
      if col.other.__class == Wall
        self.delete = true
      --damage player and enemies
      if col.other.__class.__parent == Enemy or col.other.__class == Player
        if @isEnemy ~= col.other.isEnemy
          col.other\takeDamage self, @damage
          self.delete = true

    --delete if outside room
    x, y = @getCenter!\unpack!
    rx, ry, rw, rh = @state.map.currentRoom\getWorldRect!
    if x < rx or x > rx + rw or y < ry or y > ry + rh
      @delete = true
