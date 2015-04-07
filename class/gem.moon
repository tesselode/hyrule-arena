export class Gem extends Physical
  new: (world, x, y) =>
    super world, x, y, 25, 25

    --burst movement
    @velocity = vector.new(love.math.random(500, 1000), 0)\rotated(math.random(2 * math.pi))
    @drag = 8

    @image = images.gemBlue
    @depth = 50

  update: (dt) =>
    cols = super dt
    for col in *cols
      if col.other.__class == Player
        self.delete = true

  draw: =>
    super!
