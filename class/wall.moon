export class Wall extends Physical
  new: (world, x, y, w, h) =>
    super world, x, y, w, h

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .rectangle 'fill', @world\getRect self
