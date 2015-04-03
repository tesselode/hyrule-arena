export class Physical
  drawHitbox: true

  new: (@world, x, y, w, h) =>
    @world\add self, x, y, w, h
    @velocity = vector.new 0, 0
    @filter = (other) => false

  getCenter: =>
    x, y, w, h = @world\getRect self
    vector x + w/2, y + h/2

  update: (dt) =>
    --movement
    x, y = @world\getRect self
    _, _, cols = @world\move self, x + @velocity.x * dt, y + @velocity.y * dt, @filter
    return cols

  draw: =>
    --draw hitboxes (debugging)
    if @@drawHitbox
      with love.graphics
        .setColor 255, 255, 255, 150
        .rectangle 'fill', @world\getRect self
