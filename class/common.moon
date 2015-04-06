export class Common
  new: =>
    @timer = tick.group!
    @depth = 0

  update: (dt) =>
    @timer\update dt
