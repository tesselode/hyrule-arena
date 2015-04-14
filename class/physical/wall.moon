export class Wall extends Physical
  new: (state, x, y, w, h) =>
    super state, x, y, w, h

    @shadowVisible = false

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .rectangle 'fill', @state.world\getRect self
