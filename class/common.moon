export class Common
  new: =>
    @timer = tick.group!
    @tween = flux.group!
    @depth = 0

  update: (dt) =>
    @timer\update dt
    @flux\update dt
