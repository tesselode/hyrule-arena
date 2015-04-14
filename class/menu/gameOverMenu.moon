export class GameOverMenu extends Common
  new: (@state) =>
    super!

    @y = BASE_HEIGHT + 200

  flyUp: =>
    @tween\to(self, 0.5, {y: BASE_HEIGHT - 100})

  flyDown: =>
    @tween\to(self, 1, {y: BASE_HEIGHT + 200})

  draw: (topLeftX, topLeftY) =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .setFont fonts.title
      .print 'Game over', topLeftX + 512 - fonts.title\getWidth('Game over') / 2, topLeftY + @y
