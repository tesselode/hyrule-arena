export class Physical extends Common
  new: (@world, x, y, w, h) =>
    super!
    @world\add self, x, y, w, h
    @z = 0
    @velocity = vector!
    @drag = 0
    @delete = false

    @filter = (other) => 'cross'

    @shadowVisible = false

  getCenter: =>
    x, y, w, h = @world\getRect self
    vector x + w/2, y + h/2

  setPosition: (x, y) =>
    @world\update self, x, y

  setPositionCentered: (x, y) =>
    _, _, w, h = @world\getRect self
    @setPosition x - w/2, y - h/2

  update: (dt) =>
    super dt

    --drag
    with @velocity
      .x = util.interpolate .x, 0, dt * @drag -- go from current vel to 0 at a rate of dt * 10
      .y = util.interpolate .y, 0, dt * @drag

    --movement
    x, y = @world\getRect self
    _, _, cols = @world\move self, x + @velocity.x * dt, y + @velocity.y * dt, @filter
    return cols

  drawShadow: =>
    --draw shadow
    if @shadowVisible
      with love.graphics
        .setColor 255, 255, 255, 255
        .draw images.shadow, @getCenter!.x, @getCenter!.y, 0, 1, 1, images.shadow\getWidth! / 2

  draw: =>
    --draw hitboxes (debugging)
    if true
      with love.graphics
        if @isEnemy
          .setColor 255, 0, 0, 255
        else
          .setColor 255, 255, 255, 255
        x, y, w, h = @world\getRect self
        .rectangle 'fill', x, y - @z, w, h

    --draw image
    if @image
      with love.graphics
        .setColor 255, 255, 255, 255
        x, y, w, h = @world\getRect self
        .draw @image, x, y

  onDelete: =>
