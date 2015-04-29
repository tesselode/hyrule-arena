export class Heart extends Physical
  new: (state, x, y) =>
    super state, x, y, TILE_SIZE / 2, TILE_SIZE / 2

    @shadowVisible = false
    @blinkingVisible = true
    @blinkingSpeed = 0
    @blinkingTimer = 1
    --blinking behavior
    @timer\delay (-> @blinkingSpeed = 10), 1
    @timer\delay (-> @blinkingSpeed = 15), 2
    @timer\delay (-> @delete = true), 3

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

    @image = images.heart
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
        sounds.heart\play!
        if col.other.health < col.other.maxHealth
          col.other.health += 1

        --sound stuff
        sounds.rupee\stop!
        sounds.rupee\setPitch 1 + love.math.random() * .1
        sounds.rupee\play!

    --blinking effect
    @blinkingTimer -= @blinkingSpeed * dt
    while @blinkingTimer <= 0
      @blinkingTimer += 1
      @blinkingVisible = not @blinkingVisible

  draw: =>
    if @blinkingVisible
      super!
