export class Wall extends Physical
  new: (state, x, y, w, h, @quad = roomQuads.wall) =>
    super state, x, y, w, h

    @shadowVisible = false

  draw: =>
    -- with love.graphics
    --   .setColor 255, 255, 255, 255
    --   .rectangle 'fill', @state.world\getRect self

    x, y, width, height = @state.world\getRect self
    _, _, quadWidth, quadHeight = @quad\getViewport!

    with love.graphics
      scale = 1

      .setStencil ->
        .setColor 255, 255, 255
        .rectangle 'fill', x, y, width, height

      for imageX = x, x + width, quadWidth * scale
        for imageY = y, y + height, quadHeight * scale
          .draw images.environment, @quad, imageX, imageY, 0, scale, scale

      .setStencil!
