export class Physical
  @drawHitbox = true

  new: (x, y, w, h) =>
    gamestate.current!.world\add self, x, y, w, h
    @velocity = vector.new 0, 0
    @filter = (item, other) ->
      return false

  update: (dt) =>
    --movement
    x, y = gamestate.current!.world\getRect self
    gamestate.current!.world\move self, x + @velocity.x * dt, y + @velocity.y * dt, @filter

  draw: =>
    if @@drawHitbox
      with love.graphics
        .setColor 255, 255, 255, 150
        .rectangle 'fill', gamestate.current!.world\getRect self
