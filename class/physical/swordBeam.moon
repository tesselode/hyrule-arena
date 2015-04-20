export class SwordBeam extends Projectile
  new: (state, x, y, @direction) =>
    super state, x, y, 10, 10, 400, @direction

    @image = images.swordBeam

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @image, @getCenter!.x, @getCenter!.y, @direction, 1, 1, @image\getWidth! / 2, @image\getHeight! / 2
