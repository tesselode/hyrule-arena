export class Gem extends Physical
  new: (world, x, y) =>
    super world, x, y, 25, 25

    @shadowVisible = false

    --burst movement
    @velocity = vector.new(love.math.random(500, 1000), 0)\rotated(math.random(2 * math.pi))
    @drag = 8

    @filter = (other) =>
      if other.__class == Wall
        return 'slide'
      else
        return false
    --allow the player to pick up gems after a certain time period
    @timer\delay (->
      @filter = (other) =>
        if other.__class == Wall
          return 'slide'
        else
          return 'cross'),
      .5

    @image = images.gemBlue
    @depth = 50

  update: (dt) =>
    cols = super dt
    for col in *cols
      if col.other.__class == Player
        self.delete = true

  draw: =>
    super!
