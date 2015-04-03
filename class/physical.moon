export class Physical
  drawHitbox: true

  new: (@world, x, y, w, h) =>
    @world\add self, x, y, w, h
    @velocity = vector.new 0, 0
    @filter = (other) => false

  update: (dt) =>
    --movement
    x, y = @world\getRect self

    -- will return newX, newY, cols, len
    return @world\move self, x + @velocity.x * dt, y + @velocity.y * dt, @filter

  draw: =>
    --draw hitboxes (debugging)
    if @@drawHitbox
      with love.graphics
        .setColor 255, 255, 255, 150
        .rectangle 'fill', @world\getRect self
