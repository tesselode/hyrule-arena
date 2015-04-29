export class TitleMenu extends Common
  new: (@state) =>
    super!

    @y = 85

  flyUp: =>
    @tween\to(self, 0.5, {y: -100})\ease('quadin')

  flyDown: =>
    @tween\to(self, 0.5, {y: 85})

  draw: (topLeftX, topLeftY) =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .setFont fonts.title
      .print 'Hyrule Arena', topLeftX + BASE_WIDTH / 2 - fonts.title\getWidth('Hyrule Arena') / 2, topLeftY + @y
      .setFont fonts.menu
      .print 'Press enter to start', topLeftX + BASE_WIDTH / 2 - fonts.menu\getWidth('Press enter to start') / 2, topLeftY + @y + 35
      .print 'High score: '..saveData.highScore, topLeftX + BASE_WIDTH / 2 - fonts.menu\getWidth('High score: '..saveData.highScore) / 2, topLeftY + @y - 85
