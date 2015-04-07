export class Common
  new: =>
    @timer = tick.group!
    @tween = flux.group!
    @depth = 0

  update: (dt) =>
    @timer\update dt
    @tween\update dt
