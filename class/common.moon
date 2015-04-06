export class Common
  new: =>
    @timer = tick.group!

  update: (dt) =>
    @timer\update dt
