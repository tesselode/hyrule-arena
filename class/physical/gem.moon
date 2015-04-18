export class Gem extends Physical
  new: (state, x, y) =>
    super state, x, y, 24, 24

    @shadowVisible = false
    @blinkingVisible = true
    @blinkingSpeed = 0
    @blinkingTimer = 1
    --blinking behavior
    @timer\delay (-> @blinkingSpeed = 10), .75
    @timer\delay (-> @blinkingSpeed = 15), 1.5
    @timer\delay (-> @delete = true), 2.5
    --burst movement
    @velocity = vector.new(love.math.random(500, 1000), 0)\rotated(math.random(2 * math.pi))
    @drag = 8

    @filter = (other) =>
      if other.__class == Wall or other.__class == Door
        return 'slide'
      else
        return false
    --allow the player to pick up gems after a certain time period
    @timer\delay (->
      @filter = (other) =>
        if other.__class == Wall or other.__class == Door
          return 'slide'
        else
          return 'cross'),
      .5

    @image = images.gemBlue
    @depth += 50

  update: (dt) =>
    cols = super dt
    for col in *cols
      --bounce off of walls
      if col.other.__class == Wall
        @velocity = -@velocity
      --get collected by the player
      if col.other.__class == Player
        self.delete = true
        @state.gameFlow.multiplier += 0.1

    --blinking effect
    @blinkingTimer -= @blinkingSpeed * dt
    while @blinkingTimer <= 0
      @blinkingTimer += 1
      @blinkingVisible = not @blinkingVisible

  draw: =>
    if @blinkingVisible
      super!
