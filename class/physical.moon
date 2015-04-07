export class Physical extends Common
  drawHitbox: true

  new: (@world, x, y, w, h) =>
    super!
    @world\add self, x, y, w, h
    @velocity = vector!
    @drag = 0
    @z = 0
    @filter = (other) => 'cross'
    @drawShadow = false

  getCenter: =>
    x, y, w, h = @world\getRect self
    vector x + w/2, y + h/2

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

  draw: =>
    --draw shadow
    if @drawShadow
      with love.graphics
        .setColor 255, 255, 255, 255
        .draw images.shadow, @getCenter!.x, @getCenter!.y, 0, 1, 1, images.shadow\getWidth! / 2

    --draw hitboxes (debugging)
    if @@drawHitbox
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
