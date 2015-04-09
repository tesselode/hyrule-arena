export class Common
  new: =>
    @timer = tick.group!
    @tween = flux.group!
    @depth = love.math.random!

  update: (dt) =>
    @timer\update dt
    @tween\update dt
