export class Whoosh extends Physical
  new: (state, x, y, @direction) =>
    super state, x, y, 5, 5

    @velocity = vector(300, 0)\rotated(@direction)
    @timer\delay (-> @delete = true), 0.07

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw images.whoosh, @getCenter!.x, @getCenter!.y, @direction, 1, 1, images.whoosh\getWidth! / 2, images.whoosh\getHeight! / 2
