export class Physical extends Common
  new: (@state, x, y, w, h) =>
    super!
    @state.world\add self, x, y, w, h
    @z = 0
    @velocity = vector!
    @drag = 0
    @delete = false

    @filter = (other) => 'cross'

    @shadowVisible = false

  getCenter: =>
    x, y, w, h = @state.world\getRect self
    vector x + w/2, y + h/2

  setPosition: (x, y) =>
    @state.world\update self, x, y

  setPositionCentered: (x, y) =>
    _, _, w, h = @state.world\getRect self
    @setPosition x - w/2, y - h/2

  update: (dt) =>
    super dt

    --drag
    with @velocity
      .x = util.interpolate .x, 0, dt * @drag -- go from current vel to 0 at a rate of dt * 10
      .y = util.interpolate .y, 0, dt * @drag

    --movement
    x, y = @state.world\getRect self
    _, _, cols = @state.world\move self, x + @velocity.x * dt, y + @velocity.y * dt, @filter
    return cols

  drawShadow: (ox = 0, oy = 0) =>
    --draw shadow
    if @shadowVisible
      with love.graphics
        .setColor 255, 255, 255, 255
        .draw images.shadow, @getCenter!.x + ox, @getCenter!.y + oy, 0, 1, 1, images.shadow\getWidth! / 2

  draw: =>
    --draw image
    with love.graphics
      if @image
        .setColor 255, 255, 255, 255
        x, y, w, h = @state.world\getRect self
        .draw @image, x, y
      else
        if @isEnemy
          .setColor 255, 0, 0, 255
        else
          .setColor 255, 255, 255, 255
        x, y, w, h = @state.world\getRect self
        .rectangle 'fill', x, y - @z, w, h

  onDelete: =>
